import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/home_page.dart';
import 'features/explore/explore_page.dart';
import 'features/create_trip/create_trip_page.dart';
import 'features/matches/matches_page.dart';
import 'features/wishlist/wishlist_page.dart';
import 'shared/widgets/main_scaffold.dart';

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
    ShellRoute(
      builder: (context, state, child) {
        // Determine current index based on location
        final location = state.uri.toString();
        int idx = 0;
        if (location.startsWith('/explore')) idx = 1;
        else if (location.startsWith('/create')) idx = 2;
        else if (location.startsWith('/matches')) idx = 3;
        else if (location.startsWith('/wishlist')) idx = 4;
        // Default is 0 (home)
        return MainScaffold(child: child, currentIndex: idx);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExplorePage(),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateTripPage(),
        ),
        GoRoute(
          path: '/matches',
          builder: (context, state) => const MatchesPage(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistPage(),
        ),
      ],
    ),
  ],
); 