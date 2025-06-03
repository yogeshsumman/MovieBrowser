import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/movie.dart';

// Purpose: Handles HTTP requests to the OMDB API for fetching movie data.
// Provides methods to search movies by query and fetch details by IMDb ID.
// Uses a static API key for authentication.
class ApiService {
  static const String _baseUrl = 'http://www.omdbapi.com/';
  static const String _apiKey = '928d2bde';

  // Searches movies by query and page number
  Future<List<Movie>> searchMovies(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?s=${Uri.encodeQueryComponent(query)}&page=$page&apikey=$_apiKey'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          final List<dynamic> results = data['Search'];
          return results.map((json) => Movie.fromJson(json)).toList();
        } else {
          throw Exception(data['Error'] ?? 'Failed to search movies');
        }
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  // Fetches details for a specific movie by IMDb ID
  Future<Movie> fetchMovieDetails(String imdbId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?i=$imdbId&apikey=$_apiKey'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Response'] == 'True') {
          return Movie.fromJson(data);
        } else {
          throw Exception(data['Error'] ?? 'Failed to fetch movie details');
        }
      } else {
        throw Exception('Failed to fetch movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }
}