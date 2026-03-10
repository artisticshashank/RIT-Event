import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:autonexa/theme/pallete.dart';
import 'package:autonexa/router.dart';
import 'package:autonexa/features/auth/controller/auth_controller.dart';
import 'package:autonexa/core/common/loader.dart';

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
    // In a real scenario, fetch the current user to initialize App state.
    // We'll mimic finishing load after checking session.
    _checkSession();
  }

  void _checkSession() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Simulate mapping session data to our userProvider
      // A more robust app does this via a futureProvider to fetch user data.
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
      theme: Pallete.darkModeAppTheme, // Default to a premium dark mode
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          // If the user data is populated we return 'loggedInRoute'
          final user = ref.watch(userProvider);
          if (user != null) {
            return loggedInRoute;
          }
          return loggedOutRoute;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
