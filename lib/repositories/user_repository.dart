import 'dart:async';

import 'package:android_guru/exceptions/auth_exception.dart';
import 'package:android_guru/exceptions/base_exception.dart';
import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:optional/optional.dart';

class UserRepository {
  final NetworkInfo networkInfo;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseDatabase _firebaseDatabase;

  UserRepository({
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
    @required FirebaseDatabase firebaseDatabase,
    @required NetworkInfo this.networkInfo
  })
      :
    _googleSignIn = googleSignIn ?? GoogleSignIn(),
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
    _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;


  Future<Either<BaseException, UserCredential>> signInWithEmailAndPassword ({
    @required String email,
    @required String password,
  }) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
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

  Future<Either<BaseException, UserCredential>> signUp ({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
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

  Future<Either<BaseException, UserCredential>> signInWithGoogle() async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
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

  Future<Either<BaseException, Optional>> logout() async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return Right(Optional.empty());
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<BaseException, List<dynamic>>> getRating() async {
    var isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    var usersSnapshot = await _firebaseDatabase.reference()
        .child('users')
        .orderByChild('points')
        .limitToLast(10)
        .once();

    var usersData = [];
    usersSnapshot.value.map((userId, user) {
      usersData.add({
        "username": user['username'],
        "points": user['points']
      });
      return MapEntry(userId, user);
    });
    usersData.sort((b, a) => a['points'].compareTo(b['points'])); //sorting in descending order
    return Right(usersData);
  }

  User get user => _firebaseAuth.currentUser;
}