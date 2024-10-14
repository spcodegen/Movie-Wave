class TvShow {
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final String firstAirDate;

  TvShow({
    required this.name,
    this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.firstAirDate,
  });

  //Method to convert the JSON data to dart object
  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      name: json["name"] ?? "",
      posterPath: json["poster_path"] as String?,
      overview: json["overview"] ?? "",
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      firstAirDate: json["irst_air_date"] ?? "",
    );
  }
}
