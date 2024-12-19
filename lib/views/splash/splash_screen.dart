import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme's background color
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white; // Set dark mode background to black, light mode to blue

    return Scaffold(
      backgroundColor: backgroundColor, // Set background color based on the theme
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Icon
              Image.asset(
                'assets/images/app_logo.png', // Replace with your logo asset
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              // App Name
              const Text(
                'Movie App',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

