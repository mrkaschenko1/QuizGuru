import 'package:android_guru/ui/tabs/ratingTab.dart';
import 'package:android_guru/ui/tabs/testsTab.dart';
import 'package:android_guru/ui/tabs/userTab.dart';
import 'package:android_guru/ui/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum Tabs { TESTS, RATING, USER }

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _pageController;
  Tabs _currentIndex;

  @override
  void initState() {
    _pageController = PageController(keepPage: true);
    _currentIndex = Tabs.TESTS;
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
              userName: 'Have fun',
              isUserTab: _currentIndex == Tabs.USER,
            ),
            Expanded(
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (newPage) {
                    setState(() {
                      _currentIndex = Tabs.values[newPage];
                    });
                  },
                  children: [TestsTab(), RatingTab(), UserTab()]),
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.checkSquare,
            ),
            title: Text(''),
          ),
          const BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.star,
              ),
              title: Text('')),
          const BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.user,
              ),
              title: Text('')),
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
