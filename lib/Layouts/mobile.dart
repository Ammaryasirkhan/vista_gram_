import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vista_gram_/Pages/HomePage/home_screen_items.dart';

import '../utils/colors.dart';

class MobileS extends StatefulWidget {
  const MobileS({super.key});

  @override
  State<MobileS> createState() => _MobileSState();
}

class _MobileSState extends State<MobileS> {
  int _page = 0;
  late PageController pageController;
  String username = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void naviagtetoTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body:

        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          onPageChanged: onPageChanged,
          controller: pageController,
        ),
        bottomNavigationBar: CupertinoTabBar(onTap: naviagtetoTapped, items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                color: _page == 0 ? ColorRes.app : Colors.black,
              ),
              label: 'home',
              backgroundColor: ColorRes.app),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? ColorRes.app : Colors.black,
              ),
              label: 'search',
              backgroundColor: ColorRes.app),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.post_add,
                color: _page == 2 ? ColorRes.app : Colors.black,
              ),
              label: 'post',
              backgroundColor: ColorRes.app),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: _page == 3 ? ColorRes.app : Colors.black,
              ),
              label: 'notification',
              backgroundColor: ColorRes.app),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_rounded,
                color: _page == 4 ? ColorRes.app : Colors.black,
              ),
              label: 'profile',
              backgroundColor: ColorRes.app),
        ]));
  }
}
