import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreService {
  var db = FirebaseFirestore.instance;
  Future createUser(Map<String, dynamic> json) async {
    await db.collection('users').add(json).then((value) => value.get());
  }

  Future getUser() async {
    await db.collection('users').doc().get();
  }
}
