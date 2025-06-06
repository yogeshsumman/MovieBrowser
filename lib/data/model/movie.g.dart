// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  imdbId: json['imdbID'] as String,
  title: json['Title'] as String,
  year: json['Year'] as String,
  poster: json['Poster'] as String,
  type: json['Type'] as String,
  genre: json['Genre'] as String?,
  director: json['Director'] as String?,
  actors: json['Actors'] as String?,
  plot: json['Plot'] as String?,
  imdbRating: json['imdbRating'] as String?,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'imdbID': instance.imdbId,
  'Title': instance.title,
  'Year': instance.year,
  'Poster': instance.poster,
  'Type': instance.type,
  'Genre': instance.genre,
  'Director': instance.director,
  'Actors': instance.actors,
  'Plot': instance.plot,
  'imdbRating': instance.imdbRating,
};
