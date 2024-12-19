import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/movie_list_model.dart';


class HorizontalMovieList extends StatelessWidget {
  final String title;
  final PagingController<int, Result> pagingController;
  final void Function(Result movie) onMovieTap;

  const HorizontalMovieList({
    Key? key,
    required this.title,
    required this.pagingController,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200, // Set a fixed height for horizontal scroll
            
            child: PagedListView<int, Result>(
              pagingController: pagingController,
              scrollDirection: Axis.horizontal, // Horizontal scroll
              builderDelegate: PagedChildBuilderDelegate<Result>(
                itemBuilder: (context, movie, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () => onMovieTap(movie),
                      child: Card(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.grey[100] : Colors.black54,
                        elevation: 2,
                        shadowColor: Colors.black38,
                        child: Container(
                          width: 170,
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft:Radius.circular(8.0,),topRight:Radius.circular(8.0,) ), // Adjust the radius to your preference
                                  child:CachedNetworkImage(
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
                                  )

                                ),

                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                firstPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (context) =>
                const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



