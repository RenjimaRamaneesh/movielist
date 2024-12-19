import 'package:get/get.dart';

import '../bindings/detail_binding.dart';
import '../bindings/movie_list_bindings.dart';

import '../views/details/detail_screen.dart';
import '../views/home/home_screen.dart';
import '../views/splash/splash_controller.dart';
import '../views/splash/splash_screen.dart';


class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeScreen(),
      binding: MovieListBinding(), // Bind all dependencies required for HomeScreen
    ),
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SplashController()); // Bind the SplashController
      }),
    ),
    GetPage(
      name: '/movieDetail',
      page: () => DetailScreen(movie:Get.arguments,),
      binding: DetailBinding(), // Ensure DetailScreen has the required controller
    ),
  ];
}

