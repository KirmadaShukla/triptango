import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triptango/features/auth/presentation/providers/auth_provider.dart';
import 'package:triptango/features/home/provider/home_provider.dart';
import 'app_router.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/themes/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'TravelTribe',
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      routerConfig: appRouter,
    );
  }
}
