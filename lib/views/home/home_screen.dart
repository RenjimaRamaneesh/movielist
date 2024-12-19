import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/movie_list_model.dart';
import '../../themes/theme_controller.dart';
import '../common/movie_list_item.dart';
import 'home_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: themeController.toggleTheme, // Toggle the theme dynamically
            );
          }),
        ],
      ),
      body: AnimatedSwitcher(

        duration: const Duration(milliseconds: 300), // Duration of the theme change animation
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0),
          child: SingleChildScrollView(
            key: ValueKey<bool>(themeController.isDarkMode.value), // Key to trigger animation when theme changes
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorite Movies Section
                Obx(() {
                  if (controller.hasFavoriteMovies.value) {
                    return HorizontalMovieList(
                      title: 'Favorite Movies',
                      pagingController: controller.favoriteMoviesPagingController,
                      onMovieTap: (movie) {
                        Get.toNamed('/movieDetail', arguments: movie);
                      },
                    );
                  }
                  return const SizedBox.shrink(); // Empty widget if no favorite movies
                }),

                // Watchlist Movies Section
                Obx(() {
                  if (controller.hasWatchlistMovies.value) {
                    return HorizontalMovieList(
                      title: 'Watchlist Movies',
                      pagingController: controller.watchlistMoviesPagingController,
                      onMovieTap: (movie) {
                        Get.toNamed('/movieDetail', arguments: movie);
                      },
                    );
                  }
                  return const SizedBox.shrink(); // Empty widget if no watchlist movies
                }),


                // Main Movie List (Vertical Scrolling)
                const Text("All Movies",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PagedGridView<int, Result>(
                      pagingController: controller.moviesPagingController,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      builderDelegate: PagedChildBuilderDelegate<Result>(
                        itemBuilder: (context, movie, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed('/movieDetail', arguments: movie);
                            },
                            child: Card(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.grey[900],
                              elevation: 3,
                              shadowColor: Colors.black38,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft:Radius.circular(8.0,),topRight:Radius.circular(8.0,) ), // Adjust the radius to your preference
                                    child:

                                    CachedNetworkImage(
                                      imageUrl: movie.posterPath != null
                                          ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                          : 'https://via.placeholder.com/500', // Placeholder URL
                                      fit: BoxFit.fill,
                                      height: 150,
                                      width: double.infinity,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey, // Set the shimmer background color
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0,left: 10,right: 10),
                                    child: Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,) ,

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        firstPageProgressIndicatorBuilder: (context) =>
                        const Center(child: CircularProgressIndicator(color: Colors.red)),
                        newPageProgressIndicatorBuilder: (context) =>
                        const Center(child: CircularProgressIndicator(color: Colors.red)),
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 5.0, // Spacing between columns
                        mainAxisSpacing: 6.0, // Spacing between rows
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




























/*PagedListView<int, Result>(
                  pagingController: controller.moviesPagingController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling in nested list
                  builderDelegate: PagedChildBuilderDelegate<Result>(
                    itemBuilder: (context, movie, index) {
                      return ListTile(
                        leading: Image.network(
                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.originalTitle),
                        onTap: () {
                          Get.toNamed('/movieDetail', arguments: movie);
                        },
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) =>
                    const Center(child: CircularProgressIndicator(color: Colors.red,)),
                    newPageProgressIndicatorBuilder: (context) =>
                    const Center(child: CircularProgressIndicator(color: Colors.red,)),
                  ),
                ),*/


