import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/movie_list_model.dart';
import 'package:get/get.dart';

import '../common/theme_button.dart';
import '../home/home_controller.dart';
import 'detail_controller.dart';


class DetailScreen extends StatelessWidget {
  final Result movie;
  final DetailController _movieController = Get.put(DetailController());

  DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Update favorite and watchlist status
    _movieController.updateFavoriteAndWatchlistStatus(movie.id);

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CachedNetworkImage(
                    imageUrl: movie.posterPath != null
                        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                        : 'https://via.placeholder.com/500', // Placeholder URL
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.grey, // Set the shimmer background color
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),


                  const SizedBox(height: 10),
                  const Text('Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(movie.overview),
                  Text('Language: ${movie.originalLanguage.toUpperCase()}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star,color: Colors.yellow,size: 24,),
                      const SizedBox(width:5.0,),
                      Text('${movie.voteAverage} ', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      const Text('Ratings', style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ThemeButton(
                    text: _movieController.isFavorite.value
                        ? 'Remove from Favorite'
                        : 'Add to Favorite',
                    onPressed: () => _movieController.toggleFavorite(movie.id),
                  ),
                  const SizedBox(height: 10),
                  ThemeButton(
                    text: _movieController.isInWatchlist.value
                        ? 'Remove from Watchlist'
                        : 'Add to Watchlist',
                    onPressed: () => _movieController.toggleWatchlist(movie.id),
                  ),
                ],
              )),
              const SizedBox(height: 10),
              Obx(() {
                if (_movieController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red,));
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}


