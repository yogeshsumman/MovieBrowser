import 'package:flutter/material.dart';

// Purpose: Provides a reusable dropdown widget for selecting a genre to filter
// movies. Displays a list of genres in a styled DropdownButtonFormField, with an
// "All Genres" option. Calls onChanged when a genre is selected, triggering a
// movie grid update in HomeScreen.
class GenreDropdown extends StatelessWidget {
  final List<String> genres;
  final String? selectedGenre;
  final Function(String?) onChanged;

  const GenreDropdown({
    Key? key,
    required this.genres,
    required this.selectedGenre,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGenre,
      decoration: InputDecoration(
        labelText: 'Select Genre',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Genres'),
        ),
        ...genres.map((genre) => DropdownMenuItem<String>(
              value: genre,
              child: Text(genre),
            )),
      ],
      onChanged: onChanged,
      isExpanded: true,
      menuMaxHeight: 300.0, // Scrollable for many genres
    );
  }
}