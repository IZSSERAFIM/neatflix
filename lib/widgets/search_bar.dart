import 'package:flutter/material.dart';

class NeatflixSearchBar extends StatefulWidget {
  const NeatflixSearchBar({super.key});

  @override
  State<NeatflixSearchBar> createState() => _NeatflixSearchBarState();
}

class _NeatflixSearchBarState extends State<NeatflixSearchBar> {
  String query = '';
  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: onQueryChanged,
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
