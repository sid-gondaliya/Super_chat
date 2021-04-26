import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_chat/Screens/Constant/constant.dart';
import 'package:super_chat/Screens/bottomnavigationbar_model.dart';
import 'package:super_chat/Screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  UserCredential newuser;
  String firebaseuseruid;
  bool isLoading = false;
  String email;
  String password;
  String username;
  String bio;
  int userid;
  File imagefile;
  String imageurl;

  @override
  void initState() {
    super.initState();
    idlength();
  }

  Future<void> idlength() async {
    userid = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.size);
  }

  void opengallary(BuildContext context) async {
    try {
      var pic = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        imagefile = File(pic.path);
      });
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      var msg = 'An error occurred, Please check your credentials !';
      if (e.message != null) {
        msg = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: EdgeInsets.all(8),
          content: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.black));
    } catch (e) {
      print(e);
    }
  }

  void opencamera(BuildContext context) async {
    try {
      var pic = await ImagePicker().getImage(source: ImageSource.camera);
      setState(() {
        imagefile = File(pic.path);
      });
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      var msg = 'An error occurred, Please check your credentials !';
      if (e.message != null) {
        msg = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: EdgeInsets.all(8),
          content: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.black));
    } catch (e) {
      print(e);
    }
  }

  Future<void> showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            title: Text(
              'Make a Choice',
              style: TextStyle(fontSize: 20),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      'Gallary',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      opengallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  GestureDetector(
                    child: Text(
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('𝗦𝘂𝗽𝗲𝗿 𝗖𝗵𝗮𝘁'),
        ),
        body: isLoading == false
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: (imagefile != null)
                                  ? FileImage(imagefile)
                                  : AssetImage('images/logo.png'),
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
                          ],
                        ),
                      ),
                      TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: inputdecoration),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextField(
                        obscureText: true,
                        textCapitalization: TextCapitalization.none,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: inputdecoration.copyWith(
                            labelText: 'Enter your password'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextField(
                        onChanged: (value) {
                          username = value;
                        },
                        decoration: inputdecoration.copyWith(
                            labelText: 'Create Username'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextField(
                        onChanged: (value) {
                          bio = value;
                        },
                        decoration: inputdecoration.copyWith(
                            labelText: 'Enter Your Bio'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.035,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32))))),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              if (imagefile != null) {
                                newuser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email.trim(),
                                        password: password.trim());

                                if (newuser != null) {
                                  firebaseuseruid = newuser.user.uid;

                                  Navigator.of(context)
                                      .pushNamed(Bottomnavigationbar.id);
                                }
                              }
                            } on PlatformException catch (e) {
                              var msg =
                                  'An error occurred, Please check your credentials !';
                              if (e.message != null) {
                                msg = e.message;
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      padding: EdgeInsets.all(8),
                                      content: Text(
                                        msg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.black));
                              setState(() {
                                isLoading = false;
                              });
                            } on FirebaseAuthException catch (e) {
                              var msg =
                                  'An error occurred, Please check your credentials !';
                              if (e.message != null) {
                                msg = e.message;
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      padding: EdgeInsets.all(8),
                                      content: Text(
                                        msg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.black));
                              setState(() {
                                isLoading = false;
                              });
                            }

                            if (imagefile != null) {
                              try {
                                final Reference ref = FirebaseStorage.instance
                                    .ref()
                                    .child('user_images')
                                    .child(_auth.currentUser.uid + '.jpg');
                                await ref.putFile(imagefile);
                                imageurl = await ref.getDownloadURL();

                                if (userid != null && imageurl != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(firebaseuseruid)
                                      .set({
                                    'user-id': userid + 1,
                                    'email': email.toString().trim(),
                                    'username': username.toString().trim(),
                                    'password': password.toString().trim(),
                                    'imageurl': imageurl,
                                    'bio': bio.toString().trim(),
                                  });
                                }
                              } on PlatformException catch (e) {
                                var msg =
                                    'An error occurred, Please check your credentials !';
                                if (e.message != null) {
                                  msg = e.message;
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        padding: EdgeInsets.all(8),
                                        content: Text(
                                          msg,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        backgroundColor: Colors.black));
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      padding: EdgeInsets.all(8),
                                      content: const Text(
                                        'Please add an Image !',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.black));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(13),
                            child: const Text(
                              'ꜱɪɢɴ ᴜᴘ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.id);
                        },
                        child: const Text(
                          'ɪ ᴀʟʀᴇᴀᴅʏ ʜᴀᴠᴇ ᴀɴ ᴀᴄᴄᴏᴜɴᴛ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
