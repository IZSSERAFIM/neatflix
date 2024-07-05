import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/data/data.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              isList: true,
            );
          },
        ),
      ),
      body: CustomScrollView(
        controller: _scrollcontroller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('mylist'),
                title: 'My List',
                contentList: myList,
                isHorizontal: false,
              ),
            ),
          ),
        ],
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
  @override
  void initState() {
    super.initState();
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                key: PageStorageKey('mylist'),
                title: 'My List',
                contentList: myList,
                isHorizontal: true,
                isOriginals: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
