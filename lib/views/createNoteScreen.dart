import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flopkart/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController noteController = TextEditingController();
  TextEditingController textController = TextEditingController();
  User? userid = FirebaseAuth.instance.currentUser;
  bool pinned = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Create a Note")),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: "Enter Title",
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
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: "Body",
                    hintText: "Enter Body",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:  Color.fromARGB(255, 229, 222, 222),// Background color
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border(top: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black), right: BorderSide(color: Colors.black), left: BorderSide(color: Colors.black))
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pin this Note", style: TextStyle(fontSize: 16.0, color: Colors.black),),
                      Switch(
                        value: pinned,
                        onChanged: (value) {
                          setState(() {
                            pinned = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var note = noteController.text.trim();
                    var text = textController.text.trim();
                    if (note != "") {
                      try {
                        await FirebaseFirestore.instance
                            .collection("notes")
                            .doc()
                            .set({
                          "createdAt": DateTime.now(),
                          "title": note,
                          "body": text,
                          "userid": userid?.uid,
                          "pinned": pinned,
                        });
                        Get.off(() => HomeScreen());
                      } on FirebaseAuthException catch (e) {
                        print("Error $e");
                      }
                    } else {}
                  },
                  child: Text("Add Note"))
            ])));
  }
}
