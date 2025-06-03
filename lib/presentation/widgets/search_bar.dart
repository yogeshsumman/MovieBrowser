import 'dart:async';
import 'package:flutter/material.dart';

// Purpose: Provides a reusable search bar widget for the movie browsing app.
// Uses a TextEditingController to capture user input and includes debouncing to
// prevent excessive API calls. Calls the onSearch callback with the query when
// the user stops typing for 500ms.
class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  // Handles text changes with debouncing
  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(widget.controller.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Search movies...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      ),
    );
  }
}