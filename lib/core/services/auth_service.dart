import 'dart:async';

import 'package:chat_app/core/constants.dart';
import 'package:chat_app/core/models/message_model.dart';
import 'package:chat_app/core/models/payloads/chat_payload.dart';
import 'package:chat_app/core/models/payloads/signup_payload.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/payloads/login_payload.dart';

abstract class AuthService {
  FutureOr<UserModel?> signUp(SignupPayload payload);
  FutureOr<UserModel?> login(LoginPayload payload);
  Future loadChat(LoginPayload payload);
  Future logout();
}

class FirebaseAuthService implements AuthService {
  // final FirebaseAuth _instance;
  // AuthService(this._instance );

  final usersRef = FirebaseFirestore.instance
      .collection(Constants.firebaseUsersCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
  final conversationRef = FirebaseFirestore.instance
      .collection("Conversations")
      .withConverter<MessageModel>(
        fromFirestore: (snapshots, _) =>
            MessageModel.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
  final chatRef =
      FirebaseFirestore.instance.collection(Constants.firebaseUsersCollection);

  @override
  FutureOr<UserModel?> signUp(SignupPayload payload) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: payload.email!,
        password: payload.password!,
      );
      final user = UserModel.fromPayload(payload);
      // usersRef.add(UserModel.fromPayload(payload));
      await usersRef
          .doc(payload.email)
          .set(user)
          .catchError((error, stackTrace) {
        debugPrint('Oops! Error occurred while saving biodata');
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
        userCredential.user?.delete();
        throw Exception(
            'Could not complete your registration, please try again.');
      });
      return user;

      ///
    } on FirebaseAuthException catch (e) {
      String error = 'An unknown error occurred, please try again';
      switch (e.code) {
        case 'email-already-in-use':
          error = 'User with this email already exist';
          break;
        case 'invalid-email':
          error = 'Please use a valid email address and try again';
          break;
        case 'operation-not-allowed':
          error =
              'Oops! your account appears to have been flagged, please contact support.';
          break;
        case 'weak-password':
          error = 'Password should contain at least one(1) uppercase character,'
              'one(1) number and minimum of eight(8) characters long';
          break;
      }
      throw Exception(error);
    } on Exception catch (e, st) {
      print(e);
      debugPrintStack(stackTrace: st);
    }
  }

  FutureOr<UserModel?> searchUsers(String search) async {
    try {
      final doc = await usersRef.doc(search).get();
      if (doc.exists) {
        var docdata = doc.data();
        return docdata;
      }
    } on FirebaseAuthException catch (e) {
      print('ERROR====');
      print(e);
    }
    return null;
  }

  @override
  FutureOr<UserModel?> login(LoginPayload payload) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: payload.email!,
        password: payload.password!,
      );
      final doc = await usersRef.doc(payload.email).get();
      if (doc.exists) {
        return doc.data()!;
      }
    } on FirebaseAuthException catch (e) {
      String error = 'An unknown error occurred, please try again';
      switch (e.code) {
        case 'invalid-email':
          error = 'Please use a valid email address and try again';
          break;
        case 'user-disabled':
          error =
              'Oops! your account appears to have been flagged, please contact support.';
          break;
        case 'weak-password':
          error = 'Password should contain at least one(1) uppercase character,'
              'one(1) number and minimum of eight(8) characters long';
          break;
        case 'user-not-found':
        case 'wrong-password':
          error = 'Invalid login details';
          break;
      }
      throw Exception(error);
    }
  }

  @override
  Future logout() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future loadChat(LoginPayload payload) async {
    var allChat = {};
    try {
      var doc = await FirebaseFirestore.instance.doc(payload.email!).get();
      if (doc.exists) {
        var docdata = doc.data()!;
        return docdata;
      }
    } catch (e) {
      print(e.toString());
      e.toString();
    }
    return null;
  }
}
