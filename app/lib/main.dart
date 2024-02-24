import 'package:cafe_now_app/models/place.dart';
import 'package:cafe_now_app/screens/cafe_details_screen.dart';
import 'package:cafe_now_app/screens/cafe_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
        path: CafeSearchScreen.route,
        builder: (context, state) => const CafeSearchScreen(),
        routes: [
          GoRoute(
            path: CafeDetailsScreen.route,
            builder: (context, state) => CafeDetailsScreen(
              cafe: state.extra as Place,
            ),
          ),
        ]),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromRGBO(255, 179, 135, 1),
            onPrimary: Colors.black,
            secondary: Color.fromRGBO(255, 226, 210, 1),
            onSecondary: Colors.black,
            error: Colors.deepOrangeAccent,
            onError: Colors.black,
            background: Color.fromRGBO(254, 236, 226, 1),
            onBackground: Colors.black,
            surface: Color.fromRGBO(255, 252, 250, 1),
            onSurface: Colors.black),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 25.0),
          displayMedium: TextStyle(fontSize: 18.0),
          displaySmall: TextStyle(fontSize: 14.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(Colors.amber[300]),
            textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
