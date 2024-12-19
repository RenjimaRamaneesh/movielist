import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_list/models/movie_list_model.dart';

import '../models/add_remove_favourite_watchlist.dart'; //model class


class ApiService {
  final Dio _dio = Dio();

  // Base URL for the API
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Replace with your actual Bearer token
  final String _bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNGNhZWYwZjQxMDdjNzdjMzI0NjJmYjUxMWIyNTZjMyIsIm5iZiI6MTczNDUyMDIyNC4xOTgwMDAyLCJzdWIiOiI2NzYyYWRhMDU1Y2QyZGVjOThmZmRmM2IiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.JXdpDUwKQAAqvM6fcxkBXlThJkwFM30afIOcS9Zx4Mc';

  ApiService() {
    _dio.options.headers['Authorization'] = 'Bearer $_bearerToken';
    _dio.options.headers['accept'] = 'application/json';
    _dio.options.headers['content-type'] = 'application/json';
  }

  // Fetch Trending Movies
  Future<MovieListModel> fetchMovies(int page) async {
    try {
      var response = await _dio.get(
        '$_baseUrl/trending/movie/day?language=en-US&page=$page',
      );
      return MovieListModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching movies: $e");
      rethrow;
    }
  }

  // Fetch Favorite Movies
  Future<MovieListModel> fetchFavoriteMovies(int page) async {
    try {
      var response = await _dio.get(
        '$_baseUrl/account/21694996/favorite/movies?language=en-US&page=$page',
      );
      return MovieListModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching favorite movies: $e");
      rethrow;
    }
  }

  // Fetch Watchlist Movies
  Future<MovieListModel> fetchWatchlistMovies(int page) async {
    try {
      var response = await _dio.get(
        '$_baseUrl/account/21694996/watchlist/movies?language=en-US&page=$page',
      );
      return MovieListModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching watchlist movies: $e");
      rethrow;
    }
  }

  // Add to Favorite or Remove from Favourite
  Future<AddRemoveFavWatchtlistModel> addToFavorite(int mediaId, bool favorite) async {
    try {
      var response = await _dio.post(
        '$_baseUrl/account/21694996/favorite',
        data: json.encode({
          "media_type": "movie",
          "media_id": mediaId,
          "favorite": favorite,
        }),
      );

      return AddRemoveFavWatchtlistModel.fromJson(response.data);
    } catch (e) {
      print("Error adding to favorites: $e");
      rethrow;
    }
  }

  // Add to Watchlist or Remove from watchList
  Future<AddRemoveFavWatchtlistModel> addToWatchlist(int mediaId, bool watchlist) async {
    try {
      var response = await _dio.post(
        '$_baseUrl/account/21694996/watchlist',
        data: json.encode({
          "media_type": "movie",
          "media_id": mediaId,
          "watchlist": watchlist,
        }),
      );

      return AddRemoveFavWatchtlistModel.fromJson(response.data);
    } catch (e) {
      print("Error adding to watchlist: $e");
      rethrow;
    }
  }
}






