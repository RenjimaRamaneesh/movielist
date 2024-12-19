import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../home/home_controller.dart';


class DetailController extends GetxController {
  final ApiService _apiService = ApiService();
  final HomeController homeController = Get.find<HomeController>();

  var isFavorite = false.obs;
  var isInWatchlist = false.obs;
  var isLoading = false.obs;

  void toggleFavorite(int movieId) async {
    try {
      isLoading.value = true;
      await _apiService.addToFavorite(movieId, !isFavorite.value);
      isFavorite.value = !isFavorite.value;

      // Refresh the favorite movies list in HomeController
      homeController.refreshFavoriteMovies();

      Get.snackbar(
        "Success",
        isFavorite.value ? "Added to Favorites" : "Removed from Favorites",snackPosition: SnackPosition.BOTTOM
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to update favorites",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleWatchlist(int movieId) async {
    try {
      isLoading.value = true;
      await _apiService.addToWatchlist(movieId, !isInWatchlist.value);
      isInWatchlist.value = !isInWatchlist.value;

      // Refresh the watchlist movies list in HomeController
      homeController.refreshWatchlistMovies();

      Get.snackbar(
        "Success",
        isInWatchlist.value ? "Added to Watchlist" : "Removed from Watchlist",snackPosition: SnackPosition.BOTTOM
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to update watchlist",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void updateFavoriteAndWatchlistStatus(int movieId) {
    isFavorite.value = homeController.isFavorite(movieId);
    isInWatchlist.value = homeController.isInWatchlist(movieId);
  }

  @override
  void onInit() {
    super.onInit();
    final movieId = Get.arguments.id;
    updateFavoriteAndWatchlistStatus(movieId);
  }
}






