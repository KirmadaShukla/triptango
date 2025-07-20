import 'package:go_router/go_router.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    // Add more routes here
  ],
); 