//movie_card.dart
import 'package:flutter/material.dart';
import '../../data/model/movie.dart';

// Purpose: Displays a single movie in a card with its poster, title, and year.
// Tappable to navigate to the movie details screen. Designed to be reusable in
// the HomeScreen's GridView.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onPressed;

  const MovieCard({Key? key, required this.movie, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        clipBehavior: Clip.antiAlias, // <-- Add this line
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: movie.poster.isNotEmpty
                  ? Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.error, size: 50),
                      ),
                    )
                  : const Center(child: Icon(Icons.movie, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    movie.year,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}