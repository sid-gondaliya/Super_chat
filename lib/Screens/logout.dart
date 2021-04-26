import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_chat/Screens/welcome_screen.dart';

class Logout extends StatefulWidget {
  static const String id = 'logout';

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final _auth = FirebaseAuth.instance;
  Map userdetail = {};
  String imageurl;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    userdata();
  }

  void userdata() async {
    final String useremail = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: useremail)
        .get()
        .then((value) {
      userdetail = value.docs.single.data();
    });
    setState(() {
      imageurl = userdetail['imageurl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (imageurl != null)
        ? SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(imageurl),
                                    fit: BoxFit.scaleDown),
                              ),
                            ),
                          ),
                          Text(
                            'Email ID',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            _auth.currentUser.email,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32))))),
                                onPressed: () {
                                  _signOut().then((value) {
                                    Navigator.of(context)
                                        .pushNamed(WelcomeScreen.id);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'ʟᴏɢᴏᴜᴛ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
