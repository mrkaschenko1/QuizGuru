import 'package:android_guru/app_localizations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RatingTab extends StatefulWidget {
  @override
  _RatingTabState createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  var _isLoading = false;
  var _users = [];

  Future<void> setRating() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    var dbRef = FirebaseDatabase.instance.reference();
    var usersSnapshot = await dbRef.child('users').orderByChild('points').limitToLast(10).once();
    var usersData = [];
    usersSnapshot.value.map((userId, user) {
      usersData.add({
        "username": user['username'],
        "points": user['points']
      });
    return MapEntry(userId, user);
    });
    usersData.sort((b, a) => a['points'].compareTo(b['points'])); //sorting in descending order
    if (this.mounted) {
      setState(() {
        _isLoading = false;
        _users = usersData;
      });
    }
  }

  @override
  void initState() {
    setRating();
    super.initState();
  }

  @override
  void dispose() {
    _users = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: setRating,
      child: _isLoading ? const Center(child: CircularProgressIndicator(),) : Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                color: Theme.of(context).cardColor.withOpacity(0.3)
            ),
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 10),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.secondary
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.school, size: 60, color: Theme.of(context).colorScheme.background,),
                        Text(
                          "${AppLocalizations.of(context).translate('top').toUpperCase()} 10", 
                          style: TextStyle(fontSize: 35, color: Theme.of(context).colorScheme.onBackground),
                        ),
                        Icon(Icons.school, size: 60, color: Theme.of(context).colorScheme.background,),
                      ]
                  ),
                ),
                Expanded(
                  child: ListView(
                  children: <Widget>[
                    ...(_users.map((elem) {
                      return Container(
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(right: 10, left: 5),
                          leading: CircleAvatar(
                            minRadius: 5,
                            maxRadius: 20,
                            child: Text(
                              (_users.indexOf(elem) + 1).toString(),
                              style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          title: Text(elem['username'], style: const TextStyle(color: Colors.black, fontSize: 25, letterSpacing: 0.5),),
                          trailing: Text('${elem['points'].toString()} ${AppLocalizations.of(context).translate('pts')}', style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 20),),
                        ),
                        margin: const EdgeInsets.only(top: 5, bottom: 2),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                            boxShadow: [const BoxShadow(color: Colors.grey)]
                        ),
                      );
                    }))
                  ],
                ),
                ),
              ]
            ),
          ),
    );
  }
}