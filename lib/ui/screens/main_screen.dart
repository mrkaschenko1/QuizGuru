// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/ui/tabs/rating_tab.dart';
import 'package:Quiz_Guru/ui/tabs/tests_tab.dart';
import 'package:Quiz_Guru/ui/tabs/user_tab.dart';
import 'package:Quiz_Guru/ui/widgets/main_app_bar.dart';

enum Tabs { tests, rating, user }

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  Tabs _currentIndex;

  @override
  void initState() {
    _pageController = PageController();
    _currentIndex = Tabs.tests;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            MainAppBar(
              isUserTab: _currentIndex == Tabs.user,
            ),
            Expanded(
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (newPage) {
                    setState(() {
                      _currentIndex = Tabs.values[newPage];
                    });
                  },
                  children: <Widget>[TestsTab(), RatingTab(), UserTab()]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme:
            IconThemeData(size: 24, color: Theme.of(context).accentColor),
        unselectedIconTheme: IconThemeData(
            size: 20, color: Theme.of(context).unselectedWidgetColor),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.checkSquare,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.star,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.user,
            ),
            label: '',
          ),
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        currentIndex: _currentIndex.index,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          });
        },
      ),
    );
  }
}
