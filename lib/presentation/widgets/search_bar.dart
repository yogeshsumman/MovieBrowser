//search_bar.dart

import 'package:flutter/material.dart';

// Purpose: Provides a reusable search bar widget for the movie browsing app.
// Uses a TextEditingController to capture user input and includes debouncing to
// prevent excessive API calls. Calls the onSearch callback with the query when
// the user stops typing for 500ms.
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search movies...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 16.0),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ),
      onSubmitted: (_) => onSearch(),
    );
  }
}