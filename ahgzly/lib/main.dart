import 'package:ahgzly/pages/homePage.dart';
import 'package:ahgzly/pages/signIn.dart';
import 'package:ahgzly/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Import your Firebase configuration
import 'package:firebase_core/firebase_core.dart';
import 'services/FirebaseAuth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthHandler(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const SignInPage(),
      },
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthenticationService();
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // User is authenticated, navigate to the homepage
            return const HomePage(); // Replace with your homepage
          } else {
            // User is not authenticated, navigate to the login page
            return const SignInPage(); // Replace with your login page
          }
        } else {
          // Show a loading indicator or splash screen while checking user authentication status
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
