import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../views/details/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(DetailController());
    Get.lazyPut(() => DetailController());// Register the DetailController for detail screen
  }
}