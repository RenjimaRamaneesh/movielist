import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final box = GetStorage();
    await box.write('isDarkMode', isDarkMode.value); // Save the theme mode
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void _loadTheme() {
    final box = GetStorage();
    isDarkMode.value = box.read('isDarkMode') ?? false;
  }
}
