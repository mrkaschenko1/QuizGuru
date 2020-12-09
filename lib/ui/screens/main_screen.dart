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
      // appBar: SliverAppBar(
      //   flexibleSpace: FlexibleSpaceBar(
      //     title: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         Text(
      //           AppLocalizations.of(context).translate('hello').toString(),
      //           style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 30,
      //               fontWeight: FontWeight.w900),
      //         ),
      //         Text(
      //           'Andrey',
      //           style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 30,
      //               fontWeight: FontWeight.w900),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            MainAppBar(
              userName: 'Have fun',
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
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 20),
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
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () async {
//          var key = FirebaseDatabase.instance.reference().child('users').push();
//          await key.set({
//            "username": "top",
//            "points": 10
//          });
//        }
//        onPressed: () async {
//          await FirebaseDatabase.instance.reference().child('counter').runTransaction((mutableData) async {
//            if (mutableData.value == null) {
//              print("null happened");
//              return mutableData;
//            } else {
//              mutableData.value++;
//            }
//            return mutableData;
//          }
//            );
//      }
//          await FirebaseDatabase.instance.reference().child('tests').push().set({
//            'title': 'Android simple quiz',
//            'total_points': 0,
//            'students_passed': 0,
//            'total_tries': 0,
//            'questions': [
//              {
//                'text': 'Is it easy?',
//                'options': [
//                  {
//                    'text': 'yes',
//                    'right': true
//                  },
//                  {
//                  'text': 'no',
//                  'right': false
//                  },
//                  {
//                    'text': 'may be',
//                    'right': false
//                  },
//                ]
//              },
//              {
//                'text': 'Is it good?',
//                'options': [
//                  {
//                    'text': 'yes',
//                    'right': true
//                  },
//                  {
//                    'text': 'may be',
//                    'right': false
//                  },
//                ]
//              },
//              {
//                'text': 'Are you sure?',
//                'options': [
//                  {
//                    'text': 'yes',
//                    'right': true
//                  },
//                  {
//                    'text': 'no',
//                    'right': false
//                  },
//                ]
//              },
//              {
//                'text': 'Come on?',
//                'options': [
//                  {
//                    'text': 'yes',
//                    'right': true
//                  },
//                  {
//                    'text': 'may be',
//                    'right': false
//                  },
//                  {
//                    'text': 'no',
//                    'right': false
//                  },
//                  {
//                    'text': 'hell no',
//                    'right': false
//                  },
//                ]
//              },
//            ],
//          });
//        },
//      ),
  }
}
