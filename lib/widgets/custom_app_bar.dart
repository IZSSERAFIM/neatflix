import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neatflix/assets.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:neatflix/screens/screens.dart';

class CustomAppBar extends StatelessWidget {
  final double scrollOffset;
  final bool isHome;
  final bool isList;
  final bool isSearch;
  final bool isProfile;
  final bool isPlayer;
  const CustomAppBar({
    this.scrollOffset = 0.0,
    this.isHome = false,
    this.isList = false,
    this.isSearch = false,
    this.isProfile = false,
    this.isPlayer = false,
  });
  @override
  Widget build(BuildContext context) {
    late int PageIndex;
    if (isHome) {
      PageIndex = 0;
    } else if (isList) {
      PageIndex = 1;
    } else if (isSearch) {
      PageIndex = 2;
    } else if (isProfile) {
      PageIndex = 3;
    } else if (isPlayer) {
      PageIndex = 4;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      color:
          Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
      child: Responsive(
        mobile: _CustomAppBarMobile(PageIndex),
        desktop: _CustomAppBarDesktop(PageIndex: PageIndex),
      ),
    );
  }
}

class _CustomAppBarMobile extends StatelessWidget {
  final int PageIndex;
  const _CustomAppBarMobile(this.PageIndex);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          GestureDetector(
            child: Image.asset(Assets.netflixLogo0),
            onTap: () {
              if (PageIndex == 0) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12.0),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (PageIndex == 3) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.person_outline,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBarDesktop extends StatelessWidget {
  final int PageIndex;
  const _CustomAppBarDesktop({required this.PageIndex});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Image.asset(Assets.netflixLogo1),
          const SizedBox(width: 12.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppBarButton(
                  title: 'Home',
                  onTap: () {
                    if (PageIndex == 0) {
                      return;
                    }
                    print('Home');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                ),
                _AppBarButton(
                  title: 'List',
                  onTap: () {
                    if (PageIndex == 1) {
                      return;
                    }
                    print('List');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (PageIndex == 2) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (PageIndex == 3) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.person_outline,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  const _AppBarButton({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
