class MovieDetails {
  List<String> actors = [];
  List<String> directors = [];
  List<String> genres = [];
  String synopsis = "";
  String name = "";
  String profileUrl = "";
  double rating = 0.0;

  MovieDetails({
    this.actors,
    this.directors,
    this.name,
    this.synopsis,
    this.genres,
    this.rating,
    this.profileUrl,
  });
}

class RecommendedMoviesDetails{
  String movie_id = "";
  String movie_name = "";
  String rec_by = "";

  RecommendedMoviesDetails({this.movie_id, this.movie_name, this.rec_by});
}
