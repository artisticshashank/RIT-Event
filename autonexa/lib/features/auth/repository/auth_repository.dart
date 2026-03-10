import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:autonexa/core/failure.dart';
import 'package:autonexa/core/type_defs.dart';
import 'package:autonexa/models/user_model.dart';
import 'package:autonexa/core/providers/supabase_provider.dart';
import 'package:autonexa/core/constants/constants.dart';

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
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return left(Failure('User creation failed'));
      }

      final userModel = UserModel(
        uid: user.id,
        email: email,
        name: name,
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
      );

      // Save user to a 'users' table in Supabase
      await _supabase.from('users').insert(userModel.toMap());

      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return left(Failure('Login failed'));
      }

      // Fetch user data from 'users' table
      final userData = await _supabase
          .from('users')
          .select()
          .eq('uid', user.id)
          .single();

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
