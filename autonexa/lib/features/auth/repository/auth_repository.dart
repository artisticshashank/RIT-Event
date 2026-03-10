import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:autonexa/core/failure.dart';
import 'package:autonexa/core/type_defs.dart';
import 'package:autonexa/models/user_model.dart';
import 'package:autonexa/models/enums.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(supabase: ref.read(supabaseProvider));
});

class AuthRepository {
  final sb.SupabaseClient _supabase;

  AuthRepository({required sb.SupabaseClient supabase}) : _supabase = supabase;

  Stream<sb.User?> get authStateChange =>
      _supabase.auth.onAuthStateChange.map((event) => event.session?.user);

  FutureEither<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required ProviderCategory role,
  }) async {
    try {
      // 1. Create the Auth User
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'role': role.name},
      );

      final user = response.user;
      if (user == null) {
        return left(Failure('User creation failed in Auth.'));
      }

      final userModel = UserModel(
        id: user.id,
        email: email,
        name: name,
        role: role,
      );

      // 2. Insert into custom table (using upsert to prevent unique constraint crashes)
      await _supabase.from('users').upsert(userModel.toMap());

      return right(userModel);
    } catch (e) {
      // If the insert fails, it will be caught here.
      // In a production app, you might want to delete the auth user here to prevent orphaned accounts.
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Authenticate
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return left(Failure('Invalid login credentials.'));
      }

      // 2. Fetch User Profile
      // Using maybeSingle() instead of single() prevents a hard crash if the profile is missing
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userData == null) {
        return left(
          Failure('Auth succeeded, but no public profile found for this user.'),
        );
      }

      return right(UserModel.fromMap(userData));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> getUserData(String uid) async {
    try {
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (userData == null) {
        return left(Failure('User profile not found.'));
      }
      return right(UserModel.fromMap(userData));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid logOut() async {
    try {
      await _supabase.auth.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
