import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> getUsername() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('UserName')) {
        return data['UserName'];
      }
    }
  } catch (e) {
    print('Error fetching username: $e');
  }

  return 'User not found';
}

class NameWidget extends StatefulWidget {
  const NameWidget({super.key});
  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  User? userlog = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator(color: Colors.white, radius: 50.0,);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              Align(
                child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/008/442/086/original/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg',
                    height: 100.0,
                    width: 100.0),
              ),
              Align(
                child: Text(
                  '${snapshot.data}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ],
          );
        }
      },
    );
  }
}