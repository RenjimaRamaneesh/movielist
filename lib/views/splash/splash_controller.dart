import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize the animation controller
    animationController = AnimationController(
      duration: const Duration(seconds: 2), // 2 seconds animation
      vsync: this,
    );

    // Set up fade-in animation
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    // Start the animation
    animationController.forward();

    // Navigate to the next screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/'); // Navigate to the Movie List Screen
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
