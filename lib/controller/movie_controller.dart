import 'package:flutter/material.dart';
import '../data/model/movie.dart';
import '../data/repositories/movie_repository.dart';

// Purpose: Manages movie data fetching and filtering for the app. Interfaces with
// MovieRepository to fetch movies, genres, and details, and provides filtering
// logic for genres. Manages UI controllers for search and scrolling.
class MovieController {
  final MovieRepository _repository;
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  MovieController(this._repository);

  // Fetches popular movies
  Future<List<Movie>> fetchPopularMovies(int page) async {
    try {
      final movies = await _repository.fetchPopularMovies(page);
      return await _fetchMoviesWithGenres(movies);
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  // Searches movies by query
  Future<List<Movie>> searchMovies(String query, int page) async {
    try {
      final movies = await _repository.searchMovies(query, page);
      return await _fetchMoviesWithGenres(movies);
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  // Fetches genres
  Future<List<String>> fetchGenres() async {
    try {
      return await _repository.getGenres();
    } catch (e) {
      throw Exception('Failed to load genres: $e');
    }
  }

  // Fetches movie details to get genres
  Future<List<Movie>> _fetchMoviesWithGenres(List<Movie> movies) async {
    final List<Movie> detailedMovies = [];
    for (var movie in movies) {
      try {
        final detailedMovie = await _repository.fetchMovieDetails(movie.imdbId);
        detailedMovies.add(detailedMovie);
      } catch (e) {
        // Skip movies with failed details fetch
        print('Failed to fetch details for ${movie.title}: $e');
      }
    }
    return detailedMovies;
  }

  // Filters movies by genre, case-insensitive
  List<Movie> filterByGenre(List<Movie> movies, String? genre) {
    if (genre == null || genre.isEmpty) return movies;
    return movies.where((movie) {
      if (movie.genre.isEmpty) return false;
      final movieGenres = movie.genre
          .split(', ')
          .map((g) => g.trim().toLowerCase())
          .toList();
      return movieGenres.contains(genre.toLowerCase());
    }).toList();
  }

  // Fetches movie details by IMDb ID
  Future<Movie> fetchMovieDetails(String imdbId) async {
    try {
      return await _repository.fetchMovieDetails(imdbId);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  void dispose() {
    searchController.dispose();
    scrollController.dispose();
  }
}