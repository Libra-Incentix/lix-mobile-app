import 'package:flutter/material.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/deals_screen.dart';
import 'package:lix/screens/views/bottom_tabs/earn_screen.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen.dart';
import 'package:lix/screens/views/bottom_tabs/more_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    DealsScreen(),
    EarnScreen(),
    MoreScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedItemColor: const Color.fromRGBO(115, 115, 115, 1),
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 30),
        selectedLabelStyle: const TextStyle(color: Colors.black),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Image(
                image: AssetImage(ImageAssets.tabIcHome),
                height: 24,
                width: 24),
            icon: Image(
                image: AssetImage(ImageAssets.tabIcHomeInactive),
                height: 24,
                width: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
                image: AssetImage(ImageAssets.tabIcDeals),
                height: 24,
                width: 24),
            icon: Image(
                image: AssetImage(ImageAssets.tabIcDealsInactive),
                height: 24,
                width: 24),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
                image: AssetImage(ImageAssets.tabIcEarn),
                height: 24,
                width: 24),
            icon: Image(
                image: AssetImage(ImageAssets.tabIcEarnInactive),
                height: 24,
                width: 24),
            label: 'Earn',
          ),
          BottomNavigationBarItem(
            activeIcon: Image(
                image: AssetImage(ImageAssets.tabIcDots),
                height: 24,
                width: 24),
            icon: Image(
                image: AssetImage(ImageAssets.tabIcDotsInactive),
                height: 24,
                width: 24),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
