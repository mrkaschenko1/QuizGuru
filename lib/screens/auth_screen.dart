import 'dart:math';

import 'package:android_guru/widgets/animated_wave.dart';
import 'package:android_guru/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _fireBaseRef = FirebaseDatabase.instance.reference();
  var _isLoading = false;

  void submitAuthForm({String email, String username, String password, bool isLogin, BuildContext ctx}) async {
    var userCredentials;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        userCredentials =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(userCredentials);
        await _fireBaseRef.child('users').child(userCredentials.user.uid).set({
          "username": username,
          "email": email,
          "points": 0,
          "tests_passed": [],
        });
      }
    } catch (err) {
      var message;
      try {
        message = err.message;
      } catch (err) {
        message = 'An error occurred, try again';
      }

      Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          )
      );
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void signInWithGoogle(BuildContext ctx) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(
          credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        var userProfile = await _fireBaseRef.child('users').child(currentUser.uid).once();
        if (userProfile.value == null) {
          await _fireBaseRef.child('users').child(currentUser.uid).set({
            "username": currentUser.displayName,
            "email": currentUser.email,
            "points": 0,
            "tests_passed": [],
          });
        }
      }
    } catch (e) {
      var message;
      try {
        message = e.message;
      } catch (err) {
        message = 'An error occurred, try again';
      }

      Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          )
      );
    } finally {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
          children: [
            onTop(Transform.rotate(
              angle: pi,
              child: AnimatedWave(
                height: 160,
                speed: 0.8,
                offset: pi / 8,
              ),
            )),
            onBottom(AnimatedWave(
              height: 160,
              speed: 0.8,
              offset: pi / 2,
            ),),
            Positioned.fill(child: AuthForm(submitAuthForm, signInWithGoogle, _isLoading)),
          ])
    );
  }

  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

  onTop(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.topCenter,
      child: child,
    ),
  );
}
