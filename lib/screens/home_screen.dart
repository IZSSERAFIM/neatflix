import 'package:flutter/material.dart';
import 'package:neatflix/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scrollOffset = 0.0;
  ScrollController _scrollcontroller = ScrollController();
  @override
  void initState() {
    _scrollcontroller = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollcontroller.offset;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[850],
        onPressed: () {},
        child: const Icon(Icons.cast),
      ),
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          scrollOffset: _scrollOffset = 0.0,
        ),
      ),
      body: CustomScrollView(
        controller: _scrollcontroller,
        slivers: [
          SliverToBoxAdapter(
              child: Container(
            color: Colors.blue,
            height: 1000.0,
          ))
        ],
      ),
    );
  }
}
