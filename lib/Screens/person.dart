import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_chat/Screens/Constant/constant.dart';

class Person extends StatefulWidget {
  static const String id = 'person';

  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  final _auth = FirebaseAuth.instance;
  Map userdetail = {};
  File imagefile;
  String username;
  String bio;
  String imageurl;
  String updateurl;

  @override
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

  void opengallary(BuildContext context) async {
    var pic = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imagefile = File(pic.path);
    });
    Navigator.of(context).pop();
  }

  void opencamera(BuildContext context) async {
    var pic = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imagefile = File(pic.path);
    });
    Navigator.of(context).pop();
  }

  Future<void> showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            title: const Text(
              'Make a Choice',
              style: TextStyle(fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text(
                      'Gallary',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      opengallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  GestureDetector(
                    child: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      opencamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (imageurl != null)
        ? Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: (imagefile != null)
                                  ? FileImage(imagefile)
                                  : NetworkImage(imageurl),
                              fit: BoxFit.scaleDown),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showdialog(context);
                      },
                      icon: Icon(Icons.add_a_photo),
                      label: const Text(
                        'Add Image',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextField(
                      controller: TextEditingController()
                        ..text = userdetail['username'],
                      onChanged: (value) {
                        username = value;
                      },
                      decoration:
                          inputdecoration.copyWith(labelText: 'Your Username'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextField(
                      controller: TextEditingController()
                        ..text = userdetail['bio'],
                      onChanged: (value) {
                        bio = value;
                      },
                      decoration:
                          inputdecoration.copyWith(labelText: 'Your Bio'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32))))),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            padding: EdgeInsets.all(8),
                            duration: Duration(milliseconds: 1000),
                            content: const Text(
                              'Please wait data updating',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            backgroundColor: Colors.black));
                        if (imagefile != null) {
                          try {
                            final Reference ref = FirebaseStorage.instance
                                .ref()
                                .child('user_images')
                                .child(_auth.currentUser.uid + '.jpg');
                            await ref.putFile(imagefile);
                            updateurl = await ref.getDownloadURL();

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser.uid)
                                .update({
                              'imageurl': updateurl
                            }).whenComplete(() => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        padding: EdgeInsets.all(8),
                                        duration: Duration(milliseconds: 1000),
                                        content: const Text(
                                          'Image Updated',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        backgroundColor: Colors.black)));
                          } catch (e) {
                            print(e);
                          }
                        }

                        if (username != null) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser.uid)
                              .update({
                            'username': username
                          }).whenComplete(() => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      padding: EdgeInsets.all(8),
                                      duration: Duration(milliseconds: 1000),
                                      content: const Text(
                                        'Username Updated',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.black)));
                        }
                        if (bio != null) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_auth.currentUser.uid)
                              .update({
                            'bio': bio
                          }).whenComplete(() => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      padding: EdgeInsets.all(8),
                                      duration: Duration(milliseconds: 1000),
                                      content: const Text(
                                        'Bio Updated',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.black)));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: const Text(
                          'ᴜᴘᴅᴀᴛᴇ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
