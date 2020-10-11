import 'dart:async';

import 'package:android_guru/exceptions/auth_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:optional/optional.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseDatabase _firebaseDatabase;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn, FirebaseDatabase firebaseDatabase})
      :
    _googleSignIn = googleSignIn ?? GoogleSignIn(),
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
    _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;


  Future<Either<AuthException, UserCredential>> signInWithEmailAndPassword ({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential signInResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return Right(signInResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<AuthException, UserCredential>> signUp ({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential signUpResult = await _firebaseAuth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await _firebaseDatabase.reference().child('users').child(signUpResult.user.uid).set({
        "username": username,
        "email": email,
        "points": 0,
        "tests_passed": [],
      });
      return Right(signUpResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<AuthException, UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _firebaseAuth.signInWithCredential(
          credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _firebaseAuth.currentUser;
        assert(user.uid == currentUser.uid);

        var userProfile = await _firebaseDatabase.reference().child('users').child(currentUser.uid).once();
        if (userProfile.value == null) {
          await _firebaseDatabase.reference().child('users').child(currentUser.uid).set({
            "username": currentUser.displayName,
            "email": currentUser.email,
            "points": 0,
            "tests_passed": [],
          });
        }
      }
      return Right(authResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<AuthException, Optional>> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return Right(Optional.empty());
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  User get user => _firebaseAuth.currentUser;

}