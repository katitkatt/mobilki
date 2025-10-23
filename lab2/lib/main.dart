import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'second_screen.dart';
import 'third_screen.dart';
import 'main_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        path: '/second',
        builder: (context, state) => SecondScreen(),
      ),
      GoRoute(
        path: '/third',
        builder: (context, state) => ThirdScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navigation App',
      routerConfig: _router,
    );
  }
}