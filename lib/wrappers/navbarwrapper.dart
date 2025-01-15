import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:realestate/Screens/add.dart';
import 'package:realestate/Screens/favorites.dart';
import 'package:realestate/Screens/homepage.dart';
import 'package:sizer/sizer.dart';

class NavBarWrapper extends StatefulWidget {
  const NavBarWrapper({super.key});

  @override
  State<NavBarWrapper> createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper> {
  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  int maxCount = 3;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> bottomBarPages = [
      const HomePage(),
      const AddProperty(),
      const FavoritesPage(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(

              notchBottomBarController: _controller,
              color: const Color(0xff132A35),
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              notchColor: const Color.fromARGB(255, 52, 57, 60),

              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: const Icon(
                    Icons.home_outlined,
                    color: Colors.white70,
                  ),
                  activeItem: const Icon(
                    Icons.home_outlined,
                    color: Colors.blueAccent,
                  ),
                  itemLabelWidget:  Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp
                    ),
                  ),
                ),
                BottomBarItem(
                  inActiveItem: const Icon(Icons.add_outlined, color: Colors.white70),
                  activeItem: const Icon(
                    Icons.add_outlined,
                    color: Colors.blueAccent,
                  ),
                  itemLabelWidget: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp
                    ),
                  )
                ),
                BottomBarItem(
                  inActiveItem: const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white70,
                  ),
                  activeItem: const Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabelWidget: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp
                    ),
                  )
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}