import 'package:flutter/material.dart';
import 'package:stocks_app/screens/auth/login_screen.dart';
import 'package:stocks_app/screens/auth/signup_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
    };
  }
}
