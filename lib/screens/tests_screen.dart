import 'package:android_guru/app_localizations.dart';
import 'package:android_guru/screens/settings_screen.dart';
import 'package:android_guru/widgets/ratingTab.dart';
import 'package:android_guru/widgets/testsTab.dart';
import 'package:android_guru/widgets/userTab.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Tabs {
  TESTS,
  RATING,
  USER
}

class TestsScreen extends StatefulWidget {
  static const routeName = '/tests';

  @override
  _TestsScreenState createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen>{
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
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context).translate('app_name').toString()),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => SettingsScreen(),
              maintainState: true,
            ));
          },),
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async {
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
          },),
        ],
      ),
      body: PageView(
          controller: _pageController,
          onPageChanged: (newPage) {
            setState((){
              _currentIndex = Tabs.values[newPage];
            });
          },
          children: [TestsTab(), RatingTab(), UserTab()]
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            title: Text(StringUtils.capitalize(AppLocalizations.of(context).translate('quizzes_tab')).toString())
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text(StringUtils.capitalize(AppLocalizations.of(context).translate('rating_tab')).toString())
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(StringUtils.capitalize(AppLocalizations.of(context).translate('profile_tab')).toString())
        ),
      ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.background,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        currentIndex: _currentIndex.index,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 300),curve: Curves.easeIn);
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
