import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class MovieDatabaseHelper {
  static const String _dbName = 'movies.db';
  static const int _dbVersion = 1;

  static const String tableMovies = 'movies';
  static const String tableFavoriteMovies = 'favorite_movies';
  static const String tableWatchlistMovies = 'watchlist_movies';

  static Database? _database;

  // Singleton pattern to ensure only one instance of the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create tables if they don't exist
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // Create tables for movies, favorite movies, and watchlist movies
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableMovies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        posterPath TEXT,
        overview TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableFavoriteMovies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        posterPath TEXT,
        overview TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE $tableWatchlistMovies (
        id INTEGER PRIMARY KEY,
        title TEXT,
        posterPath TEXT,
        overview TEXT
      );
    ''');
  }

  // Insert movie into database
  Future<void> insertMovie(String table, Map<String, dynamic> movie) async {
    final db = await database;
    await db.insert(table, movie, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all movies from a table
  Future<List<Map<String, dynamic>>> getMovies(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Clear all data from a table
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }
}
