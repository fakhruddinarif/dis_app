import 'package:dis_app/features/auth/screens/register_screen.dart';
import 'package:dis_app/features/auth/screens/login_screen.dart';
import 'package:dis_app/features/auth/screens/welcome_screen.dart';
import 'package:dis_app/features/auth/screens/change_profile.dart';
import 'package:dis_app/features/auth/screens/changePass_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DIS App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/change-profile': (context) => EditProfileScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
      },
    );
  }
}