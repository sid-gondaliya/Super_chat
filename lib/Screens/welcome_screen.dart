import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:super_chat/Screens/login_screen.dart';
import 'package:super_chat/Screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('𝗦𝘂𝗽𝗲𝗿 𝗖𝗵𝗮𝘁'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 70,
                  ),
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                FittedBox(
                  alignment: Alignment.center,
                  child: ColorizeAnimatedTextKit(
                      text: [
                        '🅢🅤🅟🅔🅡 🅒🅗🅐🅣',
                        '🅢🅤🅟🅔🅡 🅒🅗🅐🅣',
                        '🅢🅤🅟🅔🅡 🅒🅗🅐🅣',
                      ],
                      textStyle: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                      colors: [
                        Colors.red,
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                      ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))))),
                    onPressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text(
                        'ʟᴏɢ ɪɴ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))))),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupScreen.id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Text(
                        'ꜱɪɢɴ ᴜᴘ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
