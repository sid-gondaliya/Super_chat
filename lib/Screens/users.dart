import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_chat/Screens/chat_screen.dart';

class Users extends StatefulWidget {
  static const String id = 'users';

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final _auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  void getuser() {
    try {
      user = _auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (user != null)
        ? Scaffold(
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isNotEqualTo: user.email)
                      .snapshots(),
                  builder: (context, streamsnapshot) {
                    if (streamsnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final doc = streamsnapshot.data.docs;
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.81,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: doc.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                doc[index]['username'],
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(doc[index]['bio'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    NetworkImage(doc[index]['imageurl']),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ChatScreen.id, arguments: {
                                  'id': doc[index]['user-id'],
                                  'username': doc[index]['username'],
                                  'image': doc[index]['imageurl'],
                                });
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ),
          )
        : Center(
            child: const Text(
              'Please Login',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          );
  }
}
