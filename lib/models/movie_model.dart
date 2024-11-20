class Movie {
  final bool adult;
  final String? backdropPath; //can be null (nullable)
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath; //can be null (nullable)
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  // final double ratings;

  Movie(
      {required this.adult,
      this.backdropPath,
      required this.genreIds,
      required this.id,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.video,
      required this.voteAverage,
      required this.voteCount,
      // required this.ratings
      
      });

  //Method to convert JSON data into a dart object

  factory Movie.fromJson(
      Map<String, dynamic>
          json) //keys are  always String but values are dynamic
  {
    return Movie(
      //handle null values(null safety)
      adult: json['adult'] ?? false, // (?? = is null show. false)
      backdropPath: json['backdrop_path'] as String?,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? "",
      originalTitle: json['original_title'] ?? "",
      overview: json['overview'] ?? "",
      popularity: (json['popularity'] ?? 0).toDouble(),
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] ?? "",
      title: json['title'] ?? "",
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      // ratings: (json['ratings']?? 0).toDouble() //(?? = is null show. 0)
    );
  }
}
