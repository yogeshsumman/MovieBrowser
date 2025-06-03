// import 'dart:convert';

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String released;
  final String plot;
  final String genre;
  final String poster;
  final String imdbRating;

  Movie({
  required this.imdbId,
  required this.title,
  required this.year,
  required this.released,
  required this.plot,
  required this.genre,
  required this.poster,
  required this.imdbRating,
});


 factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      released: json['Released'] ?? '',
      plot: json['Plot'] ?? '',
      genre: json['Genre'] ?? '',
      poster: json['Poster'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Released': released,
      'Plot': plot,
      'Genre': genre,
      'Poster': poster,
      'imdbRating': imdbRating,
    };
  }
}



