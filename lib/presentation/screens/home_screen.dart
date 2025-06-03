import 'package:flutter/material.dart';
import '../../controller/movie_controller.dart' as movie_controller;
import '../../data/model/movie.dart';
import '../widgets/genre_dropdown.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar.dart' as app;
import 'movie_details_screen.dart';

// Purpose: Displays the main screen of the movie browsing app, featuring a grid
// of movies, a search bar, a genre dropdown, and a loading indicator for
// pagination. Uses StatefulWidget and setState for state management, integrating
// with MovieController for data fetching.
class HomeScreen extends StatefulWidget {
  final movie_controller.MovieController controller;

  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  bool isLoading = false;
  int currentPage = 1;
  String searchQuery = 'movie';
  String? selectedGenre;
  List<String> genres = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    widget.controller.scrollController.addListener(_scrollListener);
  }

  // Fetches initial movies and genres
  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedGenres = await widget.controller.fetchGenres();
      final fetchedMovies = await widget.controller.searchMovies(searchQuery, 1);
      setState(() {
        genres = fetchedGenres;
        movies = widget.controller.filterByGenre(fetchedMovies, selectedGenre);
        currentPage = 1;
        isLoading = false;
        if (movies.isEmpty) {
          errorMessage = selectedGenre == null
              ? 'No movies found for query "$searchQuery". Try another search.'
              : 'No movies found for genre "$selectedGenre". Try another genre.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  // Listens for scroll end to load more movies
  void _scrollListener() {
    if (widget.controller.scrollController.position.pixels ==
            widget.controller.scrollController.position.maxScrollExtent &&
        !isLoading) {
      _fetchMovies();
    }
  }

  // Fetches movies based on search query or genre filter
  Future<void> _fetchMovies() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Movie> newMovies = await widget.controller.searchMovies(
        searchQuery.isEmpty ? 'movie' : searchQuery,
        currentPage + 1,
      );
      newMovies = widget.controller.filterByGenre(newMovies, selectedGenre);
      setState(() {
        movies.addAll(newMovies);
        currentPage++;
        isLoading = false;
        if (newMovies.isEmpty && movies.isEmpty) {
          errorMessage = selectedGenre == null
              ? 'No movies found for query "$searchQuery". Try another search.'
              : 'No movies found for genre "$selectedGenre". Try another genre.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load movies: $e';
        isLoading = false;
      });
    }
  }

  // Handles search by updating the query and refreshing movies
  void _onSearch(String query) {
    setState(() {
      searchQuery = query.isEmpty ? 'movie' : query;
      movies.clear();
      currentPage = 1;
      errorMessage = null;
    });
    _fetchMovies();
  }

  // Handles genre selection
  void _onGenreChanged(String? genre) {
    setState(() {
      selectedGenre = genre;
      movies.clear();
      currentPage = 1;
      errorMessage = null;
    });
    _fetchInitialData();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Browser'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: app.SearchBar(
                    controller: widget.controller.searchController,
                    onSearch: _onSearch,
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 150.0,
                  child: GenreDropdown(
                    genres: genres,
                    selectedGenre: selectedGenre,
                    onChanged: _onGenreChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: errorMessage != null
                ? Center(child: Text(errorMessage!, textAlign: TextAlign.center))
                : movies.isEmpty && isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : movies.isEmpty
                        ? Center(
                            child: Text(
                              selectedGenre == null
                                  ? 'No movies found for query "$searchQuery".'
                                  : 'No movies found for genre "$selectedGenre".',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GridView.builder(
                            controller: widget.controller.scrollController,
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: movies.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == movies.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final movie = movies[index];
                              return MovieCard(
                                movie: movie,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                      imdbId: movie.imdbId,
                                      controller: widget.controller,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}