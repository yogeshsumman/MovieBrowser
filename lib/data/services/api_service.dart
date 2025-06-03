import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/app_constants.dart';
import '../model/movie.dart';

// Purpose: Manages API calls to OMDB for searching movies and fetching details.
class ApiService {
  static const String _baseUrl = 'http://www.omdbapi.com/';

  // Searches movies by query and page
  Future<List<Movie>> searchMovies(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?s=$query&page=$page&apikey=${AppConstants.omdbApiKey}'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Response'] == 'True') {
          return (json['Search'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
        } else {
          throw Exception(json['Error']);
        }
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  // Fetches movie details by IMDb ID
  Future<Movie> fetchMovieDetails(String imdbId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?i=$imdbId&apikey=${AppConstants.omdbApiKey}'),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Response'] == 'True') {
          return Movie.fromJson(json);
        } else {
          throw Exception(json['Error']);
        }
      } else {
        throw Exception('Failed to fetch details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }
}