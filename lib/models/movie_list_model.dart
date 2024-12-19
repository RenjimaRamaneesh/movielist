import 'dart:convert';

/*
MovieListModel movieListModelFromJson(String str) => MovieListModel.fromJson(json.decode(str));

String movieListModelToJson(MovieListModel data) => json.encode(data.toJson());

class MovieListModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MovieListModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListModel.fromJson(Map<String, dynamic> json) => MovieListModel(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  //DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    //required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
   // releaseDate: DateTime.parse(json["release_date"]),
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
   // "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
*/


MovieListModel movieListModelFromJson(String str) => MovieListModel.fromJson(json.decode(str));

String movieListModelToJson(MovieListModel data) => json.encode(data.toJson());

class MovieListModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MovieListModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieListModel.fromJson(Map<String, dynamic> json) => MovieListModel(
    page: json["page"] ?? 0,
    results: json["results"] == null
        ? []
        : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"] ?? 0,
    totalResults: json["total_results"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"],
    genreIds: json["genre_ids"] == null
        ? []
        : List<int>.from(json["genre_ids"].map((x) => x ?? 0)),
    id: json["id"] ?? 0,
    originalLanguage: json["original_language"] ?? '',
    originalTitle: json["original_title"] ?? '',
    overview: json["overview"] ?? '',
    popularity: (json["popularity"] ?? 0).toDouble(),
    posterPath: json["poster_path"],
    title: json["title"] ?? '',
    video: json["video"] ?? false,
    voteAverage: (json["vote_average"] ?? 0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
