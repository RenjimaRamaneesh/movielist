import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../db_helper/db_helper.dart';
import '../../models/movie_list_model.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


// written the code for caching using shared_pref,sqflite and without caching, all the three blocks are working

// using shared_pref for caching
class HomeController extends GetxController {
  final PagingController<int, Result> moviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> favoriteMoviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> watchlistMoviesPagingController = PagingController(firstPageKey: 1);

  final RxBool hasFavoriteMovies = false.obs;
  final RxBool hasWatchlistMovies = false.obs;

  final RxList<Result> favoriteMovies = <Result>[].obs;
  final RxList<Result> watchlistMovies = <Result>[].obs;

  final ApiService movieService = ApiService();
  final RxBool isFetchingFavorites = false.obs;
  final RxBool isFetchingWatchlist = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    moviesPagingController.addPageRequestListener(fetchMovies);
    favoriteMoviesPagingController.addPageRequestListener(fetchFavoriteMovies);
    watchlistMoviesPagingController.addPageRequestListener(fetchWatchlistMovies);

    // Try loading cached data
    await _loadCachedMovies();

    // Initial fetch of favorite and watchlist movies
    await fetchFavoriteMovies(1);
    await fetchWatchlistMovies(1);
  }

  // Fetch Movies from API and cache them
  Future<void> fetchMovies(int pageKey) async {
    try {
      var data = await movieService.fetchMovies(pageKey);
      final isLastPage = data.results.length < 20;

      if (isLastPage) {
        moviesPagingController.appendLastPage(data.results);
      } else {
        moviesPagingController.appendPage(data.results, pageKey + 1);
      }

      // Save to cache
      await _cacheMovies(data.results);

    } catch (e) {
      moviesPagingController.error = e;
    }
  }

  // Fetch Favorite Movies from API and cache them
  Future<void> fetchFavoriteMovies(int pageKey) async {
    if (isFetchingFavorites.value) return;
    isFetchingFavorites.value = true;

    try {
      if (pageKey == 1) {
        favoriteMovies.clear();
        favoriteMoviesPagingController.itemList = null; // Reset paging controller
      }

      var data = await movieService.fetchFavoriteMovies(pageKey);
      final isLastPage = data.results.length < 20;

      favoriteMovies.addAll(data.results); // Add data to observable list
      if (isLastPage) {
        favoriteMoviesPagingController.appendLastPage(data.results);
      } else {
        favoriteMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasFavoriteMovies.value = favoriteMovies.isNotEmpty;

      // Cache the favorite movies
      await _cacheFavoriteMovies(favoriteMovies);

    } catch (e) {
      favoriteMoviesPagingController.error = e;
    } finally {
      isFetchingFavorites.value = false;
    }
  }

  // Fetch Watchlist Movies from API and cache them
  Future<void> fetchWatchlistMovies(int pageKey) async {
    if (isFetchingWatchlist.value) return;
    isFetchingWatchlist.value = true;

    try {
      if (pageKey == 1) {
        watchlistMovies.clear();
        watchlistMoviesPagingController.itemList = null; // Reset paging controller
      }

      var data = await movieService.fetchWatchlistMovies(pageKey);
      final isLastPage = data.results.length < 20;

      watchlistMovies.addAll(data.results); // Add data to observable list
      if (isLastPage) {
        watchlistMoviesPagingController.appendLastPage(data.results);
      } else {
        watchlistMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasWatchlistMovies.value = watchlistMovies.isNotEmpty;

      // Cache the watchlist movies
      await _cacheWatchlistMovies(watchlistMovies);

    } catch (e) {
      watchlistMoviesPagingController.error = e;
    } finally {
      isFetchingWatchlist.value = false;
    }
  }

  // Cache Movies to Shared Preferences
  Future<void> _cacheMovies(List<Result> movies) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movieStrings = movies.map((movie) => json.encode(movie.toJson())).toList();
    await prefs.setStringList('cachedMovies', movieStrings);
  }

  // Cache Favorite Movies to Shared Preferences
  Future<void> _cacheFavoriteMovies(List<Result> movies) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movieStrings = movies.map((movie) => json.encode(movie.toJson())).toList();
    await prefs.setStringList('cachedFavoriteMovies', movieStrings);
  }

  // Cache Watchlist Movies to Shared Preferences
  Future<void> _cacheWatchlistMovies(List<Result> movies) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movieStrings = movies.map((movie) => json.encode(movie.toJson())).toList();
    await prefs.setStringList('cachedWatchlistMovies', movieStrings);
  }

  // Load cached Movies from Shared Preferences
  Future<void> _loadCachedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cachedMovies = prefs.getStringList('cachedMovies');

    if (cachedMovies != null) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(json.decode(movie))).toList();
      moviesPagingController.appendPage(movieList, 2);
    }
  }

  // Load cached Favorite Movies from Shared Preferences
  Future<void> _loadCachedFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cachedMovies = prefs.getStringList('cachedFavoriteMovies');

    if (cachedMovies != null) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(json.decode(movie))).toList();
      favoriteMovies.addAll(movieList);
      hasFavoriteMovies.value = favoriteMovies.isNotEmpty;
    }
  }

  // Load cached Watchlist Movies from Shared Preferences
  Future<void> _loadCachedWatchlistMovies() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cachedMovies = prefs.getStringList('cachedWatchlistMovies');

    if (cachedMovies != null) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(json.decode(movie))).toList();
      watchlistMovies.addAll(movieList);
      hasWatchlistMovies.value = watchlistMovies.isNotEmpty;
    }
  }

  bool isFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  bool isInWatchlist(int movieId) {
    return watchlistMovies.any((movie) => movie.id == movieId);
  }

  void refreshFavoriteMovies() async {
    await fetchFavoriteMovies(1);
  }

  void refreshWatchlistMovies() async {
    await fetchWatchlistMovies(1);
  }
}


// cached using SQFlite - uncomment and run
/*class HomeController extends GetxController {
  final PagingController<int, Result> moviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> favoriteMoviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> watchlistMoviesPagingController = PagingController(firstPageKey: 1);

  final RxBool hasFavoriteMovies = false.obs;
  final RxBool hasWatchlistMovies = false.obs;

  final RxList<Result> favoriteMovies = <Result>[].obs;
  final RxList<Result> watchlistMovies = <Result>[].obs;

  final ApiService movieService = ApiService();
  final RxBool isFetchingFavorites = false.obs;
  final RxBool isFetchingWatchlist = false.obs;

  final MovieDatabaseHelper databaseHelper = MovieDatabaseHelper();

  @override
  Future<void> onInit() async {
    super.onInit();
    moviesPagingController.addPageRequestListener(fetchMovies);
    favoriteMoviesPagingController.addPageRequestListener(fetchFavoriteMovies);
    watchlistMoviesPagingController.addPageRequestListener(fetchWatchlistMovies);

    // Try loading cached data
    await _loadCachedMovies();
    await _loadCachedFavoriteMovies();
    await _loadCachedWatchlistMovies();

    // Initial fetch of favorite and watchlist movies
    await fetchFavoriteMovies(1);
    await fetchWatchlistMovies(1);
  }

  // Fetch Movies from API and cache them in SQLite
  Future<void> fetchMovies(int pageKey) async {
    try {
      var data = await movieService.fetchMovies(pageKey);
      final isLastPage = data.results.length < 20;

      if (isLastPage) {
        moviesPagingController.appendLastPage(data.results);
      } else {
        moviesPagingController.appendPage(data.results, pageKey + 1);
      }

      // Save to cache (SQLite)
      await _cacheMovies(data.results);

    } catch (e) {
      moviesPagingController.error = e;
    }
  }

  // Fetch Favorite Movies from API and cache them in SQLite
  Future<void> fetchFavoriteMovies(int pageKey) async {
    if (isFetchingFavorites.value) return;
    isFetchingFavorites.value = true;

    try {
      if (pageKey == 1) {
        favoriteMovies.clear();
        favoriteMoviesPagingController.itemList = null;
      }

      var data = await movieService.fetchFavoriteMovies(pageKey);
      final isLastPage = data.results.length < 20;

      favoriteMovies.addAll(data.results);
      if (isLastPage) {
        favoriteMoviesPagingController.appendLastPage(data.results);
      } else {
        favoriteMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasFavoriteMovies.value = favoriteMovies.isNotEmpty;

      // Cache the favorite movies (SQLite)
      await _cacheFavoriteMovies(favoriteMovies);

    } catch (e) {
      favoriteMoviesPagingController.error = e;
    } finally {
      isFetchingFavorites.value = false;
    }
  }

  // Fetch Watchlist Movies from API and cache them in SQLite
  Future<void> fetchWatchlistMovies(int pageKey) async {
    if (isFetchingWatchlist.value) return;
    isFetchingWatchlist.value = true;

    try {
      if (pageKey == 1) {
        watchlistMovies.clear();
        watchlistMoviesPagingController.itemList = null;
      }

      var data = await movieService.fetchWatchlistMovies(pageKey);
      final isLastPage = data.results.length < 20;

      watchlistMovies.addAll(data.results);
      if (isLastPage) {
        watchlistMoviesPagingController.appendLastPage(data.results);
      } else {
        watchlistMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasWatchlistMovies.value = watchlistMovies.isNotEmpty;

      // Cache the watchlist movies (SQLite)
      await _cacheWatchlistMovies(watchlistMovies);

    } catch (e) {
      watchlistMoviesPagingController.error = e;
    } finally {
      isFetchingWatchlist.value = false;
    }
  }

  // Cache Movies to SQLite
  Future<void> _cacheMovies(List<Result> movies) async {
    await databaseHelper.clearTable(MovieDatabaseHelper.tableMovies);

    for (var movie in movies) {
      await databaseHelper.insertMovie(MovieDatabaseHelper.tableMovies, movie.toJson());
    }
  }

  // Cache Favorite Movies to SQLite
  Future<void> _cacheFavoriteMovies(List<Result> movies) async {
    await databaseHelper.clearTable(MovieDatabaseHelper.tableFavoriteMovies);

    for (var movie in movies) {
      await databaseHelper.insertMovie(MovieDatabaseHelper.tableFavoriteMovies, movie.toJson());
    }
  }

  // Cache Watchlist Movies to SQLite
  Future<void> _cacheWatchlistMovies(List<Result> movies) async {
    await databaseHelper.clearTable(MovieDatabaseHelper.tableWatchlistMovies);

    for (var movie in movies) {
      await databaseHelper.insertMovie(MovieDatabaseHelper.tableWatchlistMovies, movie.toJson());
    }
  }

  // Load cached Movies from SQLite
  Future<void> _loadCachedMovies() async {
    final cachedMovies = await databaseHelper.getMovies(MovieDatabaseHelper.tableMovies);
    if (cachedMovies.isNotEmpty) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(movie)).toList();
      moviesPagingController.appendPage(movieList, 2);
    }
  }

  // Load cached Favorite Movies from SQLite
  Future<void> _loadCachedFavoriteMovies() async {
    final cachedMovies = await databaseHelper.getMovies(MovieDatabaseHelper.tableFavoriteMovies);
    if (cachedMovies.isNotEmpty) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(movie)).toList();
      favoriteMovies.addAll(movieList);
      hasFavoriteMovies.value = favoriteMovies.isNotEmpty;
    }
  }

  // Load cached Watchlist Movies from SQLite
  Future<void> _loadCachedWatchlistMovies() async {
    final cachedMovies = await databaseHelper.getMovies(MovieDatabaseHelper.tableWatchlistMovies);
    if (cachedMovies.isNotEmpty) {
      List<Result> movieList = cachedMovies.map((movie) => Result.fromJson(movie)).toList();
      watchlistMovies.addAll(movieList);
      hasWatchlistMovies.value = watchlistMovies.isNotEmpty;
    }
  }

  bool isFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  bool isInWatchlist(int movieId) {
    return watchlistMovies.any((movie) => movie.id == movieId);
  }

  void refreshFavoriteMovies() async {
    await fetchFavoriteMovies(1);
  }

  void refreshWatchlistMovies() async {
    await fetchWatchlistMovies(1);
  }
}*/




//Without caching - uncomment and run
/*

class HomeController extends GetxController {
  final PagingController<int, Result> moviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> favoriteMoviesPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Result> watchlistMoviesPagingController = PagingController(firstPageKey: 1);

  final RxBool hasFavoriteMovies = false.obs;
  final RxBool hasWatchlistMovies = false.obs;

  final RxList<Result> favoriteMovies = <Result>[].obs;
  final RxList<Result> watchlistMovies = <Result>[].obs;

  final ApiService movieService = ApiService();
  final RxBool isFetchingFavorites = false.obs;
  final RxBool isFetchingWatchlist = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    moviesPagingController.addPageRequestListener(fetchMovies);
    favoriteMoviesPagingController.addPageRequestListener(fetchFavoriteMovies);
    watchlistMoviesPagingController.addPageRequestListener(fetchWatchlistMovies);

    // Initial fetch of favorite and watchlist movies
    await fetchFavoriteMovies(1);
    await fetchWatchlistMovies(1);
  }

  Future<void> fetchMovies(int pageKey) async {
    try {
      var data = await movieService.fetchMovies(pageKey);
      final isLastPage = data.results.length < 20;
      if (isLastPage) {
        moviesPagingController.appendLastPage(data.results);
      } else {
        moviesPagingController.appendPage(data.results, pageKey + 1);
      }
    } catch (e) {
      moviesPagingController.error = e;
    }
  }

  Future<void> fetchFavoriteMovies(int pageKey) async {
    if (isFetchingFavorites.value) return;
    isFetchingFavorites.value = true;

    try {
      if (pageKey == 1) {
        favoriteMovies.clear();
        favoriteMoviesPagingController.itemList = null; // Reset paging controller
      }

      var data = await movieService.fetchFavoriteMovies(pageKey);
      final isLastPage = data.results.length < 20;

      favoriteMovies.addAll(data.results); // Add data to observable list
      if (isLastPage) {
        favoriteMoviesPagingController.appendLastPage(data.results);
      } else {
        favoriteMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasFavoriteMovies.value = favoriteMovies.isNotEmpty;
    } catch (e) {
      favoriteMoviesPagingController.error = e;
    } finally {
      isFetchingFavorites.value = false;
    }
  }

  Future<void> fetchWatchlistMovies(int pageKey) async {
    if (isFetchingWatchlist.value) return;
    isFetchingWatchlist.value = true;

    try {
      if (pageKey == 1) {
        watchlistMovies.clear();
        watchlistMoviesPagingController.itemList = null; // Reset paging controller
      }

      var data = await movieService.fetchWatchlistMovies(pageKey);
      final isLastPage = data.results.length < 20;

      watchlistMovies.addAll(data.results); // Add data to observable list
      if (isLastPage) {
        watchlistMoviesPagingController.appendLastPage(data.results);
      } else {
        watchlistMoviesPagingController.appendPage(data.results, pageKey + 1);
      }

      hasWatchlistMovies.value = watchlistMovies.isNotEmpty;
    } catch (e) {
      watchlistMoviesPagingController.error = e;
    } finally {
      isFetchingWatchlist.value = false;
    }
  }

  bool isFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  bool isInWatchlist(int movieId) {
    return watchlistMovies.any((movie) => movie.id == movieId);
  }

  void refreshFavoriteMovies() async {
    await fetchFavoriteMovies(1);
  }

  void refreshWatchlistMovies() async {
    await fetchWatchlistMovies(1);
  }
}
*/




