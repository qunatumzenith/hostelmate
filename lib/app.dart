import 'package:flutter/material.dart';
import 'package:hostelmate/core/services/auth_service.dart';
import 'package:hostelmate/ui/screens/login_screen.dart';
import 'package:hostelmate/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

class HostelMateApp extends StatelessWidget {
  const HostelMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'HostelMate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
} 