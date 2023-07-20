import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flopkart/views/edtNoteScreen.dart';
import 'package:flopkart/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({super.key});

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  TextEditingController noteController = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text("View Note")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: noteController
                ..text = Get.arguments['title'].toString(),
              decoration: const InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.black),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Color.fromARGB(255, 229, 222, 222),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              maxLines: null,
              enabled: false,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textController
                ..text = Get.arguments['body'].toString(),
              decoration: const InputDecoration(
                labelText: "Body",
                labelStyle: TextStyle(color: Colors.black),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Color.fromARGB(255, 229, 222, 222),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              maxLines: null,
              enabled: false,
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => EditNoteScreen(), arguments: {
                  'title': Get.arguments['title'],
                  'body': Get.arguments['body'],
                  'docId': Get.arguments['docId'],
                });
              },
              child: Icon(Icons.edit)),
          SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("notes")
                    .doc(Get.arguments['docId'])
                    .delete();
                Get.off(() => HomeScreen());
              },
              child: Icon(Icons.delete))
        ],
      ),
    ));
  }
}
