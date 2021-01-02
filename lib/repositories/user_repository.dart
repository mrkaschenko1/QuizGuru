// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:optional/optional.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/exceptions/auth_exception.dart';
import 'package:Quiz_Guru/exceptions/base_exception.dart';
import 'package:Quiz_Guru/exceptions/network_exception.dart';
import 'package:Quiz_Guru/models/user_model.dart';
import 'package:Quiz_Guru/network/network_info.dart';

class UserRepository {
  final NetworkInfo networkInfo;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseDatabase _firebaseDatabase;

  UserRepository(
      {@required FirebaseAuth firebaseAuth,
      @required GoogleSignIn googleSignIn,
      @required FirebaseDatabase firebaseDatabase,
      @required this.networkInfo})
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseDatabase = firebaseDatabase ?? FirebaseDatabase.instance;

  Future<Either<BaseException, UserCredential>> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      final signInResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(signInResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<BaseException, UserCredential>> signUp({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      final signUpResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseDatabase
          .reference()
          .child('users')
          .child(signUpResult.user.uid)
          .set({
        "username": username,
        "email": email,
        "points": 0,
        "tests_passed": <String>[],
        "lang": "en"
      });
      return Right(signUpResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<BaseException, UserCredential>> signInWithGoogle() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _firebaseAuth.currentUser;
        assert(user.uid == currentUser.uid);

        final userProfile = await _firebaseDatabase
            .reference()
            .child('users')
            .child(currentUser.uid)
            .once();
        if (userProfile.value == null) {
          await _firebaseDatabase
              .reference()
              .child('users')
              .child(currentUser.uid)
              .set({
            "username": currentUser.displayName,
            "email": currentUser.email,
            "points": 0,
            "tests_passed": <String>[]
          });
        }
      }
      return Right(authResult);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<BaseException, Optional>> logout() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return const Right(Optional<dynamic>.empty());
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<BaseException, List<dynamic>>> getRating() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final usersSnapshot = await _firebaseDatabase
        .reference()
        .child('users')
        .orderByChild('points')
        .limitToLast(10)
        .once();

    final usersData = <Map<String, dynamic>>[];
    usersSnapshot.value.map((String userId, Map<String, dynamic> user) {
      usersData.add(<String, dynamic>{
        "username": user['username'],
        "points": user['points']
      });
      return MapEntry(userId, user);
    });
    usersData.sort((Map<String, dynamic> b, Map<String, dynamic> a) =>
        (a['points'] as int)
            .compareTo(b['points'] as int)); //sorting in descending order
    return Right(usersData);
  }

  Future<Either<BaseException, UserModel>> getUserInfo() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkException('No internet connection'));
    }
    final fireBaseRef = _firebaseDatabase.reference();
    final currentUser = await fireBaseRef
        .child('users')
        .child(FirebaseAuth.instance.currentUser.uid)
        .once();
    final userPoints = currentUser.value['points'] as int;
    final usersBetter = await fireBaseRef
        .child('users')
        .orderByChild('points')
        .startAt(userPoints + 1)
        .once();

    int userRating;
    if (usersBetter.value == null) {
      userRating = 1;
    } else {
      userRating = usersBetter.value.length + 1 as int;
    }

    int testsCount;
    if (!(currentUser.value.containsKey('tests_passed') as bool)) {
      testsCount = 0;
    } else {
      testsCount = currentUser.value['tests_passed'].length as int;
    }

    return Right(UserModel(
        id: user.uid,
        username: currentUser.value['username'] as String,
        email: currentUser.value['email'] as String,
        testsPassedCount: testsCount,
        ratingPosition: userRating,
        points: userPoints));
  }

  User get user => _firebaseAuth.currentUser;

  String get login {
    return 'Hello';
  }
}
