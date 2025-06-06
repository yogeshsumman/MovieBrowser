// movie_repository.dart

import '../model/movie.dart';
import '../model/search_response.dart';
import '../services/api_service.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<SearchResponse> fetchPopularMovies(int page) async {
    try {
      final response = await _apiService.searchMovies('movie', page);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch popular movies: $e');
    }
  }

  Future<SearchResponse> searchMovies(String query, int page) async {
    return await _apiService.searchMovies(query, page);
  }

  Future<SearchResponse> fetchMovies(int page) async {
    return await _apiService.fetchMovies(page);
  }

  Future<Movie> fetchMovieDetails(String imdbId) async {
    try {
      final movie = await _apiService.getMovieDetails(imdbId);
      return movie;
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  Future<List<Movie>> fetchMoviesWithDetails(List<Movie> movies) async {
    try {
      final detailedMovies = await Future.wait(
        movies.map((movie) async {
          final detailedMovie = await _apiService.getMovieDetails(movie.imdbId);
          
          // 🐛 DEBUG: Print each movie’s title and genre
          print('Fetched: ${detailedMovie.title}, Genre: ${detailedMovie.genre}');
          
          return detailedMovie;
        }),
      );
      return detailedMovies;
    } catch (e) {
      print('Error fetching detailed movies: $e'); // 🐛 DEBUG: Log full error
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  Future<List<String>> getGenres() async {
    try {
      return [
        'Action',
        'Adventure',
        'Animation',
        'Biography',
        'Comedy',
        'Crime',
        'Documentary',
        'Drama',
        'Family',
        'Fantasy',
        'History',
        'Horror',
        'Music',
        'Mystery',
        'Romance',
        'Sci-Fi',
        'Sport',
        'Thriller',
        'War',
        'Western',
      ];
    } catch (e) {
      throw Exception('Failed to load genres: $e');
    }
  }
}
