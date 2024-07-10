import 'package:flutter/material.dart';

class NeatflixSearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;

  const NeatflixSearchBar({super.key, required this.onQueryChanged});

  @override
  State<NeatflixSearchBar> createState() => _NeatflixSearchBarState();
}

class _NeatflixSearchBarState extends State<NeatflixSearchBar> {
  String query = '';

  void handleQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
    widget.onQueryChanged(newQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: handleQueryChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
