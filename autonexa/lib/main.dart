import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/router.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/core/common/loader.dart';

import 'package:autonexa/models/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Make sure to replace these with your actual Supabase URL and Anon Key
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This helps track when user authentication finishes evaluating
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final user = session.user;
      ref.read(authControllerProvider.notifier).getUserData(user.id);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: Pallete.darkModeAppTheme,
        home: const Scaffold(body: Loader()),
      );
    }

    return MaterialApp.router(
      title: 'AutoNexa',
      debugShowCheckedModeBanner: false,
      theme: Pallete.lightModeAppTheme,
      darkTheme: Pallete.darkModeAppTheme,
      themeMode: ThemeMode
          .light, // Added this line to force the light theme based on UI mockup
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final user = ref.watch(userProvider);
          if (user != null) {
            switch (user.role) {
              case ProviderCategory.mechanic:
                return mechanicRoute;
              case ProviderCategory.parts_seller:
                return sellerRoute;
              case ProviderCategory.towing_agency:
                return towingRoute;
              case ProviderCategory.petrol_bunk:
                return fuelRoute;
              case ProviderCategory.admin:
                return adminRoute;
              case ProviderCategory.regular_user:
                return userRoute;
            }
          }
          return loggedOutRoute;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
