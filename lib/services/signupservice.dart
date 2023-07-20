// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../views/LoginScreen.dart';

signUpUser(String userName, String userPhone, String userEmail,
    String userPassword) async {
  User? userid = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance.collection("users").doc(userid!.uid).set({
      "UserName": userName,
      "userPhone": userPhone,
      "userEmail": userEmail,
      "Date and time": DateTime.now(),
      "userID": userid.uid
    }).then((value) => {
      FirebaseAuth.instance.signOut(),
      Get.to(() => LoginScreen()),
    });
  } on FirebaseAuthException catch (e) {
    print("Error $e");
  }
}
