import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:super_chat/Screens/bottomnavigationbar_model.dart';
import 'package:super_chat/Screens/chat_screen.dart';
import 'package:super_chat/Screens/login_screen.dart';
import 'package:super_chat/Screens/logout.dart';
import 'package:super_chat/Screens/person.dart';
import 'package:super_chat/Screens/signup_screen.dart';
import 'package:super_chat/Screens/users.dart';
import 'package:super_chat/Screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Chat',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Bottomnavigationbar();
          }
          return WelcomeScreen();
        },
      ),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        Users.id: (context) => Users(),
        Person.id: (context) => Person(),
        ChatScreen.id: (context) => ChatScreen(),
        Logout.id: (context) => Logout(),
        Bottomnavigationbar.id: (context) => Bottomnavigationbar(),
      },
    );
  }
}
