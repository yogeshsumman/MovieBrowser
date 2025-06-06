import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  @JsonKey(name: 'imdbID')
  final String imdbId;

  @JsonKey(name: 'Title')
  final String title;

  @JsonKey(name: 'Year')
  final String year;

  @JsonKey(name: 'Poster')
  final String poster;

  @JsonKey(name: 'Type')
  final String type;

  // Add these fields for details
  @JsonKey(name: 'Genre')
  final String? genre;

  @JsonKey(name: 'Director')
  final String? director;

  @JsonKey(name: 'Actors')
  final String? actors;

  @JsonKey(name: 'Plot')
  final String? plot;

  @JsonKey(name: 'imdbRating')
  final String? imdbRating;

  Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
    this.genre,
    this.director,
    this.actors,
    this.plot,
    this.imdbRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
