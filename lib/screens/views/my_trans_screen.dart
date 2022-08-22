import 'package:flutter/material.dart';
import 'package:lix/app/color_select.dart';
import 'package:lix/app/image_assets.dart';
import 'package:lix/screens/views/bottom_tabs/earn_screen.dart';
import 'package:lix/screens/views/bottom_tabs/home_screen_styles.dart';
import 'package:lix/screens/views/my_earned_view.dart';
import 'package:lix/screens/views/my_spent_view.dart';
import 'package:lix/screens/views/verify_otp_view.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class MyTransScreen extends StatefulWidget {
  const MyTransScreen({Key? key}) : super(key: key);

  @override
  State<MyTransScreen> createState() => _MyTransScreenState();
}

class _MyTransScreenState extends State<MyTransScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MyEarnedView(),
    MySpentView(),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Transactions", style: textStyleBoldBlack(16)),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: const Image(image: AssetImage(ImageAssets.arrowBack)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 36,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: ColorSelect.appThemeGrey,
              borderRadius: BorderRadius.circular(
                17,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              // give the indicator a decoration (color and border radius)
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  17.0,
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              onTap: _onItemTapped,
              tabs: [
                // first tab [you can add an icon using the icon property]
                Tab(
                  child: Text(
                    'Earned',
                    style: _selectedIndex == 0
                        ? textStyleBoldBlack(14)
                        : textStyleRegularBlack(14),
                  ),
                ),

                // second tab [you can add an icon using the icon property]
                Tab(
                  child: Text(
                    'Spend',
                    style: _selectedIndex == 1
                        ? textStyleBoldBlack(14)
                        : textStyleRegularBlack(14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: _widgetOptions.elementAt(_selectedIndex),
          )
        ],
      ),
    );
  }
}
