import 'package:flutter/material.dart';
import 'dart:async';

/// Splash screen shown while app initializes
/// Shows branding and transitions to login/home based on auth state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds then navigate
    // In a real app, you'd wait for Firebase initialization here
    Timer(const Duration(seconds: 2), () {
      // Navigation will be handled by StreamBuilder in main.dart
      // This is just for the visual delay
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background for a modern look
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon/logo
              Icon(
                Icons.chat_bubble_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              // App name
              const Text(
                'ChatBoards',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'For the New Age',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}