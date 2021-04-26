import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_chat/Screens/Constant/constant.dart';
import 'package:super_chat/Screens/bottomnavigationbar_model.dart';
import 'package:super_chat/Screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool isLoading = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

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
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 70),
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: Image.asset('images/logo.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),

                    TextField(
                      textCapitalization: TextCapitalization.none,
                      controller: emailcontroller,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: inputdecoration,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextField(
                      controller: passcontroller,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: inputdecoration.copyWith(
                          labelText: 'Enter your password'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.022,
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
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email.toString().trim(),
                                password: password.toString().trim());
                            if (user != null) {
                              Navigator.of(context)
                                  .pushNamed(Bottomnavigationbar.id);
                            }
                            emailcontroller.clear();
                            passcontroller.clear();
                          } on PlatformException catch (e) {
                            var msg =
                                'An error occurred, Please check your credentials !';
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
                            setState(() {
                              isLoading = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            var msg =
                                'An error occurred, Please check your credentials !';
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
                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(13),
                          child: const Text(
                            'ʟᴏɢ ɪɴ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignupScreen.id);
                      },
                      child: const Text(
                        'ᴄʀᴇᴀᴛᴇ ɴᴇᴡ ᴀᴄᴄᴏᴜɴᴛ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
