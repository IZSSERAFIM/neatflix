import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/data/data.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _SearchScreenMobile(),
      desktop: _SearchScreenDesktop(),
    );
  }
}

class _SearchScreenMobile extends StatefulWidget {
  const _SearchScreenMobile({super.key});

  @override
  State<_SearchScreenMobile> createState() => _SearchScreenMobileState();
}

class _SearchScreenMobileState extends State<_SearchScreenMobile> {
  ScrollController _scrollcontroller = ScrollController();
  @override
  void initState() {
    _scrollcontroller = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollcontroller.offset);
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
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (context, scrollOffset) {
            return CustomAppBar(
              scrollOffset: scrollOffset,
              isSearch: true,
            );
          },
        ),
      ),
      body: CustomScrollView(
        controller: _scrollcontroller,
        slivers: [
          SliverToBoxAdapter(
            child: NeatflixSearchBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('trending'),
                title: 'Trending',
                contentList: trending,
                isOriginals: false,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('search'),
                title: 'Search Results',
                contentList: searchResults,
                isOriginals: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchScreenDesktop extends StatefulWidget {
  const _SearchScreenDesktop({super.key});

  @override
  State<_SearchScreenDesktop> createState() => _SearchScreenDesktopState();
}

class _SearchScreenDesktopState extends State<_SearchScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isSearch: true,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: NeatflixSearchBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('trending'),
                title: 'Trending',
                contentList: trending,
                isOriginals: false,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('search'),
                title: 'Search Results',
                contentList: searchResults,
                isOriginals: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
