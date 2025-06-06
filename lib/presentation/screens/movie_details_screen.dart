import 'package:flutter/material.dart';
import '../../controller/movie_controller.dart';
import '../../data/model/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String imdbId;
  final MovieController controller;

  const MovieDetailsScreen({
    Key? key,
    required this.imdbId,
    required this.controller,
  }) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Movie? movieDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    try {
      final details = await widget.controller.getMovieDetails(widget.imdbId);
      setState(() {
        movieDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load movie details: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildRatingStars(String? rating) {
    if (rating == null || rating == 'N/A') {
      return const Text('IMDb: N/A');
    }

    final doubleRate = double.tryParse(rating) ?? 0.0;
    final starCount = (doubleRate / 2).round(); // IMDb is out of 10, we convert to 5

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'IMDb Rating: $rating',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < starCount ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 22,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(movieDetails?.title ?? 'Movie Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (movieDetails?.poster != null && movieDetails!.poster != 'N/A')
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            movieDetails!.poster,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 80),
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        movieDetails?.title ?? 'No Title',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // IMDb Rating
                      if (movieDetails?.imdbRating != null)
                        _buildRatingStars(movieDetails?.imdbRating),
                      const SizedBox(height: 24),

                      // Info Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Year', movieDetails?.year ?? 'N/A'),
                              const Divider(),
                              _buildInfoRow('Genre', movieDetails?.genre ?? 'N/A'),
                              const Divider(),
                              _buildInfoRow('Director', movieDetails?.director ?? 'N/A'),
                              const Divider(),
                              _buildInfoRow('Actors', movieDetails?.actors ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Plot
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Plot',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            movieDetails?.plot ?? 'N/A',
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
