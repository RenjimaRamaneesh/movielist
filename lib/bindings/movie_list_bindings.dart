import 'package:get/get.dart';
import 'package:movie_list/themes/theme_controller.dart';
import '../api/api_service.dart';
import '../views/details/detail_controller.dart';
import '../views/home/home_controller.dart';
import '../views/splash/splash_controller.dart';


class MovieListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService());  // Register ApiService
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DetailController());
    Get.lazyPut(() => ThemeController());
  }
}
