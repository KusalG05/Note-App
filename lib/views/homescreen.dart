import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flopkart/views/LoginScreen.dart';
import 'package:flopkart/views/createNoteScreen.dart';
import 'package:flopkart/views/edtNoteScreen.dart';
import 'package:flopkart/views/viewNoteScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../services/UserName.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // final String? userid;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userlog = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(11, 128, 238, 0.8),
          foregroundColor: Color.fromRGBO(248, 250, 252, 0.8),
          title: Text("Home Screen"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            GestureDetector(
                onTap: () => {Get.off(() => LoginScreen())},
                child: Icon(Icons.logout)),
          ],
        ),
        drawer: FractionallySizedBox(
          widthFactor: 0.7,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: NameWidget(),
                ),
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    // Handle menu item 1 tap
                  },
                ),
                ListTile(
                  title: Text('Profile'),
                  onTap: () {
                    // Handle menu item 1 tap
                  },
                ),
                ListTile(
                  title: Text('Rate Us'),
                  onTap: () {
                    // Handle menu item 2 tap
                  },
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("notes")
                .where("userid", isEqualTo: userlog?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No documentation"));
              }
              if (snapshot != null && snapshot.data != null) {
                // Retrieve the list of documents from the snapshot
                final List<QueryDocumentSnapshot> documents =
                    snapshot.data!.docs;

                // Sort the list based on a specific field (e.g., 'timestamp')
                documents
                    .sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
                return CustomScrollView(slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= documents.length) {
                        return null;
                      }
                      var title = documents[index]["title"];
                      var body = documents[index]["body"];
                      var noteId = documents[index]["userid"];
                      var time = DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(documents[index]["createdAt"].toDate());
                      var docId = documents[index].id;
                      return GestureDetector(
                        child: Card(
                          child: ListTile(
                            title: Text(
                              title,
                              // softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(time),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              GestureDetector(
                                  onTap: () async {
                                    Get.to(() => ViewNoteScreen(), arguments: {
                                      'title': title,
                                      'body': body,
                                      'docId': docId,
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye)),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  Get.to(() => EditNoteScreen(), arguments: {
                                    'title': title,
                                    'body': body,
                                    'docId': docId,
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete "${title}"'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("notes")
                                                    .doc(docId)
                                                    .delete();
                                                Get.off(() =>
                                                    HomeScreen()); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(Icons.delete)),
                            ]),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        child: Text('View'),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          Get.to(() => ViewNoteScreen(),
                                              arguments: {
                                                'title': title,
                                                'body': body,
                                                'docId': docId,
                                              });
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Edit'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Get.to(() => EditNoteScreen(),
                                              arguments: {
                                                'title': title,
                                                'body': body,
                                                'docId': docId,
                                              }); // Close the dialog
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("notes")
                                              .doc(docId)
                                              .delete();
                                          Get.off(() =>
                                              HomeScreen()); // Close the dialog
                                        },
                                      ),
                                    ]),
                              );
                            },
                          );
                        },
                      );
                    },
                    childCount: documents.length,
                  ))
                ]);
              }
              return Container();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => CreateNoteScreen());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
