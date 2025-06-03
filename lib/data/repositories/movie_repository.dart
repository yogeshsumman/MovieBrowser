import '../model/movie.dart';
import '../services/api_service.dart';

// Purpose: Acts as a repository layer to handle data operations for the movie
// browsing app, interfacing with ApiService to fetch movies, movie details, and
// genres. Uses a static genre list for filtering, as OMDB API lacks a genre endpoint.
class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  // Fetches popular movies by searching a default query
  Future<List<Movie>> fetchPopularMovies(int page) async {
    try {
      final movies = await _apiService.searchMovies('movie', page);
      return movies;
    } catch (e) {
      throw Exception('Failed to fetch popular movies: $e');
    }
  }

  // Searches movies by query
  Future<List<Movie>> searchMovies(String query, int page) async {
    try {
      final movies = await _apiService.searchMovies(query, page);
      return movies;
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  // Fetches details for a specific movie by IMDb ID
  Future<Movie> fetchMovieDetails(String imdbId) async {
    try {
      final movie = await _apiService.fetchMovieDetails(imdbId);
      return movie;
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }

  // Returns a list of genres for filtering
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