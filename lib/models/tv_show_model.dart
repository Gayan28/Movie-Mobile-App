class TVShow {
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final String firstAirDate;

  TVShow(
      {required this.name,
      this.posterPath,
      required this.overview,
      required this.voteAverage,
      required this.firstAirDate});

  //Method to convert JSON data into a dart object

  factory TVShow.fromJson(Map<String, dynamic> json) {
    return TVShow(
      name: json['name'] ?? "",
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] ?? "",
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      firstAirDate: json['first_air_date'] ?? "",
    );
  }
}
