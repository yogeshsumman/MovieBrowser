import 'package:flutter/material.dart';
import '../../controller/movie_controller.dart';
import '../../data/model/movie.dart';
import '../widgets/genre_dropdown.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar.dart' as app;
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final MovieController controller;

  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  bool isLoading = false;
  bool isFiltering = false;
  int currentPage = 1;
  String searchQuery = 'movie';
  String? selectedGenre;
  List<String> genres = [];
  String? errorMessage;
  int? totalResults;
  int? totalPages;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    widget.controller.scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedGenres = await widget.controller.fetchGenres();
      final response = searchQuery == 'movie'
          ? await widget.controller.fetchMovies(1)
          : await widget.controller.searchMovies(searchQuery, 1);

      setState(() {
        isFiltering = true;
      });

      final filteredMovies =
          await widget.controller.filterByGenre(response.movies, selectedGenre);

      setState(() {
        genres = fetchedGenres;
        movies = filteredMovies;
        totalResults = int.tryParse(response.totalResults) ?? 0;
        totalPages = (totalResults! / 10).ceil();
        currentPage = 1;
        isLoading = false;
        isFiltering = false;

        if (movies.isEmpty) {
          errorMessage = selectedGenre == null
              ? 'No movies found for query "$searchQuery". Try another search.'
              : 'No movies found for genre "${selectedGenre ?? 'All Genres'}". Try another genre.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
        isFiltering = false;
      });
    }
  }

  void _scrollListener() {
    if (widget.controller.scrollController.position.pixels ==
            widget.controller.scrollController.position.maxScrollExtent &&
        !isLoading &&
        !isFiltering &&
        (totalPages == null || currentPage < totalPages!)) {
      _fetchMoreMovies();
    }
  }

  Future<void> _fetchMoreMovies() async {
    if (totalPages != null && currentPage >= totalPages!) return;//stops from making 
    //unessesary api call when all data is loaded

    setState(() {
      isLoading = true;
    });

    try {
      final response = searchQuery == 'movie'
          ? await widget.controller.fetchMovies(currentPage + 1)
          : await widget.controller.searchMovies(searchQuery, currentPage + 1);

      setState(() {
        isFiltering = true;
      });

      final newMovies =
          await widget.controller.filterByGenre(response.movies, selectedGenre);//Filters
          //  the fetched movies by the selected genre, if any

      setState(() {
        movies.addAll(newMovies);
        totalResults = int.tryParse(response.totalResults) ?? 0;
        totalPages = (totalResults! / 10).ceil();
        currentPage++;
        isLoading = false;
        isFiltering = false;

        //If after filtering there are no movies at all, sets an error message so the UI can show it.


        if (newMovies.isEmpty && movies.isEmpty) {
          errorMessage = selectedGenre == null
              ? 'No movies found for query "$searchQuery". Try another search.'
              : 'No movies found for genre "${selectedGenre ?? 'All Genres'}". Try another genre.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load movies: $e';
        isLoading = false;
        isFiltering = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query.isEmpty ? 'movie' : query;
      movies.clear();
      currentPage = 1;
      errorMessage = null;
    });
    _fetchInitialData();
  }

  void _onGenreChanged(String? genre) {
    setState(() {
      selectedGenre = genre;
      movies.clear();
      currentPage = 1;
      errorMessage = null;
      if (genre == null) {
        searchQuery = 'movie';
        widget.controller.searchController.clear();
      }
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
                    onSearch: () =>
                        _onSearch(widget.controller.searchController.text),
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
                : movies.isEmpty && (isLoading || isFiltering)
                    ? const Center(child: CircularProgressIndicator())
                    : movies.isEmpty
                        ? Center(
                            child: Text(
                              selectedGenre == null
                                  ? 'No movies found for query "$searchQuery".'
                                  : 'No movies found for genre "${selectedGenre ?? 'All Genres'}".',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Stack(
                            children: [
                              GridView.builder(
                                controller: widget.controller.scrollController,
                                padding: const EdgeInsets.all(8.0),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: movies.length,
                                itemBuilder: (context, index) {
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
                              if (isLoading || isFiltering)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.2),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.movie,
                                                color: Colors.blueAccent,
                                                size: 48),
                                            const SizedBox(height: 16),
                                            CircularProgressIndicator(
                                              strokeWidth: 6,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blueAccent),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              isFiltering
                                                  ? "Filtering movies..."
                                                  : "Loading movies...",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}
