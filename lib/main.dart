import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/auth_service.dart';
import '/firestore_service.dart';
import '/splash_screen.dart';
import '/login_screen.dart';
import '/home_screen.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // This MUST happen before any Firebase services are used
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize message boards (run once to create boards in Firestore)
  // After first run, you can comment this out
  final firestoreService = FirestoreService();
  await firestoreService.initializeBoards();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBoards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // AuthWrapper handles navigation based on authentication state
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper that shows different screens based on authentication state
/// This is the key to automatic navigation when user logs in/out
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    
    // StreamBuilder listens to auth state changes
    // When user logs in/out, this automatically rebuilds with new data
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        // If user is logged in, show home screen
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        
        // If no user is logged in, show login screen
        return const LoginScreen();
      },
    );
  }
}