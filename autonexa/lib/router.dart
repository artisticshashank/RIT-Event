import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:autonexa/features/auth/screens/login_screen.dart';
import 'package:autonexa/features/auth/screens/signup_screen.dart';
import 'package:autonexa/features/dashboard_user/screens/user_dashboard_screen.dart';
import 'package:autonexa/features/dashboard_mechanic/screens/mechanic_dashboard_screen.dart';
import 'package:autonexa/features/dashboard_seller/screens/seller_dashboard_screen.dart';
import 'package:autonexa/features/dashboard_towing/screens/towing_dashboard_screen.dart';
import 'package:autonexa/features/dashboard_fuel/screens/fuel_dashboard_screen.dart';
import 'package:autonexa/features/dashboard_admin/screens/admin_dashboard_screen.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
    '/signup': (_) => const MaterialPage(child: SignupScreen()),
  },
);

final userRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: UserDashboardScreen())},
);

final mechanicRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: MechanicDashboardScreen())},
);

final sellerRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: SellerDashboardScreen())},
);

final towingRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: TowingDashboardScreen())},
);

final fuelRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: FuelDashboardScreen())},
);

final adminRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: AdminDashboardScreen())},
);
