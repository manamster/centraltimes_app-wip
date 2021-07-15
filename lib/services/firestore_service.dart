import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future<void> updateUserInfo({required User user}) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      var snapshot = await transaction
          .get(FirebaseFirestore.instance.collection("users").doc(user.uid));
      transaction
          .set(FirebaseFirestore.instance.collection("users").doc(user.uid), {
        "first": user.displayName?.split(" ").first ?? "",
        "last": user.displayName?.split(" ").last ?? "",
        "name": user.displayName ?? "",
        "date": snapshot.data()?["date"] ?? DateTime.now(),
        "email": user.email ?? "",
        "uid": user.uid,
      });
    });
  }

  static Future<List<Map<String, dynamic>>> getStories({String sortBy = "date", bool descending = false}) async {
    var snapshot = await FirebaseFirestore.instance.collection("stories").orderBy(sortBy, descending: descending).get();
    return snapshot.docs.map((doc) {
      var data = doc.data();
      data["id"] = doc.id;
      return data;
    }).toList();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getCategoryStream() {
    return FirebaseFirestore.instance.collection("config").doc("categories").snapshots();
  }
}
