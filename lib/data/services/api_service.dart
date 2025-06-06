//api_service.dart

import 'package:dio/dio.dart';
import '../../core/app_constants.dart';
import '../model/movie.dart';
import '../model/search_response.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient _client;

  ApiService() : _client = ApiClient(Dio());

  Future<SearchResponse> searchMovies(String query, int page) async {
    try {
      print('Searching: http://www.omdbapi.com/?s=$query&page=$page&apikey=${AppConstants.omdbApiKey}');
      final response = await _client.searchMovies(query, page, AppConstants.omdbApiKey);
      return response;
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<SearchResponse> fetchMovies(int page) async {
    return await searchMovies('movie', page);
  }

  Future<Movie> getMovieDetails(String imdbId) async {
    try {
      print('Fetching details: http://www.omdbapi.com/?i=$imdbId&plot=full&apikey=${AppConstants.omdbApiKey}');
      final response = await _client.getMovieDetails(imdbId, 'full', AppConstants.omdbApiKey);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }
}