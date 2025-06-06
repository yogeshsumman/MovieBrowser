//search_respone.dart
import 'package:json_annotation/json_annotation.dart';
import '../model/movie.dart';

part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse {
  @JsonKey(name: 'Search')
  final List<Movie> movies;

  @JsonKey(name: 'totalResults')
  final String totalResults;

  @JsonKey(name: 'Response')
  final String response;

  SearchResponse({
    required this.movies,
    required this.totalResults,
    required this.response,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}
