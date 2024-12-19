import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_list/routes/app_routes.dart';
import 'package:movie_list/themes/themes.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize GetStorage

  final box = GetStorage();
  final isDarkMode = box.read('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  MyApp({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      initialRoute: '/splash',
      getPages: AppRoutes.routes,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}


