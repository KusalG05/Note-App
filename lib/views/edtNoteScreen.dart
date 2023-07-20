import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flopkart/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController noteController = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
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
                maxLines: null),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: textController..text = Get.arguments['body'].toString(),
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
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("notes")
                    .doc(Get.arguments['docId'].toString())
                    .update({
                  'title': noteController.text.trim(),
                  'body': textController.text.trim(),
                  'createdAt': DateTime.now(),
                }).then((value) => {Get.offAll(() => HomeScreen())});
              },
              child: Icon(Icons.save))
        ],
      ),
    ));
  }
}
