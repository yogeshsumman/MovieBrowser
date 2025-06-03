import 'package:flutter/material.dart';
import '../../controller/movie_controller.dart' as movie_controller;
import '../../data/model/movie.dart';
// import '../../theme/theme.dart';

// Purpose: Displays detailed information about a selected movie, including poster,
// title, genre, year, plot, release date, and IMDb rating. Fetches data using
// MovieController and applies styles from theme.dart for consistency.
class MovieDetailsScreen extends StatefulWidget {
  final String imdbId;
  final movie_controller.MovieController controller;

  const MovieDetailsScreen({
    Key? key,
    required this.imdbId,
    required this.controller,
  }) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Movie> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = widget.controller.fetchMovieDetails(widget.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme.dart styles

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary, // Blue from theme.dart
      ),
      backgroundColor: theme.scaffoldBackgroundColor, // Light grey
      body: FutureBuilder<Movie>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No movie data found.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
                Center(
                  child: Card(
                    elevation: theme.cardTheme.elevation, // From theme.dart
                    shape: theme.cardTheme.shape, // Rounded corners
                    child: movie.poster.isNotEmpty && movie.poster != 'N/A'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              movie.poster,
                              width: 200,
                              height: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 200,
                                height: 300,
                                color: theme.colorScheme.onSurface.withOpacity(0.1),
                                child: const Icon(Icons.error, size: 50),
                              ),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 300,
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            child: const Icon(Icons.image_not_supported, size: 50),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Title
                Text(
                  movie.title,
                  style: theme.textTheme.displayLarge, // Bold, large from theme.dart
                ),
                const SizedBox(height: 8.0),
                // Genre
                Text(
                  'Genre: ${movie.genre.isEmpty ? 'N/A' : movie.genre}',
                  style: theme.textTheme.titleMedium, // Medium title style
                ),
                const SizedBox(height: 8.0),
                // Year
                Text(
                  'Year: ${movie.year.isEmpty ? 'N/A' : movie.year}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                // Release Date
                Text(
                  'Released: ${movie.released.isEmpty ? 'N/A' : movie.released}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                // IMDb Rating
                Text(
                  'IMDb Rating: ${movie.imdbRating.isEmpty ? 'N/A' : movie.imdbRating}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16.0),
                // Plot
                Text(
                  'Plot',
                  style: theme.textTheme.titleLarge, // Section header
                ),
                const SizedBox(height: 8.0),
                Card(
                  elevation: theme.cardTheme.elevation,
                  shape: theme.cardTheme.shape,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      movie.plot.isEmpty ? 'No plot available.' : movie.plot,
                      style: theme.textTheme.bodyLarge, // Body text style
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}