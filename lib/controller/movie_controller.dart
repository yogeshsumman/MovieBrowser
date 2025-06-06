import 'package:flutter/material.dart';
import '../data/model/movie.dart';
import '../data/model/search_response.dart';
import '../data/repositories/movie_repository.dart';

class MovieController {
  final MovieRepository repository;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  MovieController(this.repository);

  Future<List<String>> fetchGenres() async {
    return await repository.getGenres();
  }

  Future<SearchResponse> searchMovies(String query, int page) async {
    return await repository.searchMovies(query, page);
  }

  Future<SearchResponse> fetchMovies(int page) async {
    return await repository.fetchMovies(page);
  }

  Future<Movie> getMovieDetails(String imdbId) async {
    return await repository.fetchMovieDetails(imdbId);
  }

  // 🔧 Genre filtering with normalization applied
  Future<List<Movie>> filterByGenre(List<Movie> movies, String? genre) async {
    if (genre == null) {
      return movies; // No filtering if no genre is selected
    }

    final detailedMovies = await repository.fetchMoviesWithDetails(movies);

    final targetGenre = _normalizeGenre(genre);

    return detailedMovies.where((movie) {
      final movieGenre = movie.genre?.toLowerCase() ?? '';
      final genreList = movieGenre
          .split(',')
          .map((g) => _normalizeGenre(g.trim()))
          .toList();

      return genreList.contains(targetGenre);
    }).toList();
  }

  //Genre normalization mapping
  String _normalizeGenre(String genre) {
    final map = {
      'science fiction': 'sci-fi',
      'sci fi': 'sci-fi',
      'scifi': 'sci-fi',
      'romantic comedy': 'romance',
      'romance comedy': 'romance',
      'rom com': 'romance',
      'historical': 'history',
      'action-adventure': 'action',
      'action & adventure': 'action',
      'adventure-action': 'adventure',
      'comedy-drama': 'comedy',
      'dramedy': 'drama',
      'drama-comedy': 'drama',
      'thriller-mystery': 'thriller',
      'mystery-thriller': 'mystery',
      'crime-drama': 'crime',
      'drama-crime': 'drama',
      'fantasy-adventure': 'fantasy',
      'horror-thriller': 'horror',
      'biographical': 'biography',
      'bio': 'biography',
      'musical': 'music',
      'war-drama': 'war',
      'western-comedy': 'western',
      'family-adventure': 'family',
      'animated': 'animation',
    };
    return map[genre.toLowerCase()] ?? genre.toLowerCase();
  }

  void dispose() {
    scrollController.dispose();
    searchController.dispose();
  }
}
