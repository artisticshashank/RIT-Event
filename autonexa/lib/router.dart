import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:autonexa/features/auth/screens/login_screen.dart';
import 'package:autonexa/features/auth/screens/signup_screen.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
    '/signup': (_) => const MaterialPage(child: SignupScreen()),
  },
);

// A placeholder for the logged-in user route.
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
      child: Scaffold(
        body: Center(child: Text('Welcome to AutoNexa Dashboard!')),
      ),
    ),
  },
);
