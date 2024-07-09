import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/models/models.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _ListScreenMobile(),
      desktop: _ListScreenDesktop(),
    );
  }
}

class _ListScreenMobile extends StatefulWidget {
  const _ListScreenMobile({super.key});

  @override
  State<_ListScreenMobile> createState() => _ListScreenMobileState();
}

class _ListScreenMobileState extends State<_ListScreenMobile> {
  ScrollController _scrollcontroller = ScrollController();
  late Future<List<dynamic>> _combinedFutures;

  @override
  void initState() {
    _scrollcontroller = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollcontroller.offset);
      });
    super.initState();
    _combinedFutures = Future.wait([
      getUserPlayList(),
    ]);
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
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (context, scrollOffset) {
            return CustomAppBar(
              scrollOffset: scrollOffset,
              isList: true,
            );
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _combinedFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var combinedData = snapshot.data!;
            var listContent =
                List<Content>.from(combinedData[0] as List<dynamic>);

            return CustomScrollView(
              controller: _scrollcontroller,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: ContentList(
                      key: PageStorageKey('mylist'),
                      title: 'My List',
                      contentList: listContent,
                      isHorizontal: false,
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}

class _ListScreenDesktop extends StatefulWidget {
  const _ListScreenDesktop({super.key});

  @override
  State<_ListScreenDesktop> createState() => _ListScreenDesktopState();
}

class _ListScreenDesktopState extends State<_ListScreenDesktop> {
  late Future<List<dynamic>> _combinedFutures;
  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getUserPlayList(),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isList: true,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _combinedFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var combinedData = snapshot.data!;
            var listContent =
                List<Content>.from(combinedData[0] as List<dynamic>);

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20.0),
                  sliver: SliverToBoxAdapter(
                    child: ContentList(
                      key: PageStorageKey('mylist'),
                      title: 'My List',
                      contentList: listContent,
                      isHorizontal: true,
                      isOriginals: true,
                    ),
                  ),
                ),
              ],
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}
