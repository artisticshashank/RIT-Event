import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autonexa/models/user_model.dart';
import 'package:autonexa/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref,
      super(false); // isLoading = false

  void signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    state = true;
    final res = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
    state = false;

    res.fold(
      (l) => _showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final res = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );
    state = false;

    res.fold(
      (l) => _showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logOut() async {
    _authRepository.logOut();
    _ref.read(userProvider.notifier).update((state) => null);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
