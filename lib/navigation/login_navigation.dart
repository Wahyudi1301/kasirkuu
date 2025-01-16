import 'package:flutter/material.dart';
import '../view/login.dart';

class LoginNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
    }
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }
}
