import 'package:flutter/material.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neatflix/models/models.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..fetchHistory(),
      child: Responsive(
        mobile: _HistoryScreenMobile(),
        desktop: _HistoryScreenDesktop(),
      ),
    );
  }
}

class _HistoryScreenMobile extends StatefulWidget {
  const _HistoryScreenMobile({super.key});

  @override
  State<_HistoryScreenMobile> createState() => _HistoryScreenMobileState();
}

class _HistoryScreenMobileState extends State<_HistoryScreenMobile> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        context.read<AppBarCubit>().setOffset(_scrollController.offset);
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _onDelete(Content content) {
  //   context.read<HistoryCubit>().removeFromPlayList(content);
  // }

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
              isHistory: true,
            );
          },
        ),
      ),
      body: BlocBuilder<HistoryCubit, List<Content>>(
        builder: (context, historyContent) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 20.0),
                sliver: SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('watchhistory'),
                    title: 'Watched History',
                    contentList: historyContent,
                    isHorizontal: false,
                    // showDelete: true,
                    // onDelete: _onDelete, // 传递回调函数
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryScreenDesktop extends StatefulWidget {
  const _HistoryScreenDesktop({super.key});

  @override
  State<_HistoryScreenDesktop> createState() => _HistoryScreenDesktopState();
}

class _HistoryScreenDesktopState extends State<_HistoryScreenDesktop> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory();
  }

  // void _onDelete(Content content) {
  //   context.read<HistoryCubit>().removeFromPlayList(content);
  // }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isHistory: true,
        ),
      ),
      body: BlocBuilder<HistoryCubit, List<Content>>(
        builder: (context, historyContent) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 20.0),
                sliver: SliverToBoxAdapter(
                  child: ContentList(
                    key: PageStorageKey('watchhistory'),
                    title: 'Watched History',
                    contentList: historyContent,
                    isHorizontal: true,
                    isOriginals: true,
                    // showDelete: true,
                    // onDelete: _onDelete, // 传递回调函数
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
