import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flopkart/views/LoginScreen.dart';
import 'package:flopkart/views/createNoteScreen.dart';
import 'package:flopkart/views/edtNoteScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});
  // final String? userid;
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
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
        drawer: Drawer(
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
        body: Container(
          child: StreamBuilder(
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
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        var title = snapshot.data!.docs[index]["title"];
                        var body = snapshot.data!.docs[index]["body"];
                        var noteId = snapshot.data!.docs[index]["userid"];
                        var time = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                            snapshot.data!.docs[index]["createdAt"].toDate());
                        var docId = snapshot.data!.docs[index].id;
                        return Card(
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
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("notes")
                                        .doc(docId)
                                        .delete();
                                  },
                                  child: Icon(Icons.delete)),
                            ]),
                          ),
                        );
                      }));
                }
                return Container();
              }),
        ),
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
