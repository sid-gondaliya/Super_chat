import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:super_chat/Screens/logout.dart';
import 'package:super_chat/Screens/person.dart';
import 'package:super_chat/Screens/users.dart';

class Bottomnavigationbar extends StatefulWidget {
  static const String id = 'bottomnavigationbar';
  @override
  _BottomnavigationbarState createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  int _selectedIndex = 0;

  final _pageOptions = [Users(), Person(), Logout()];

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            title: const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 20),
            ),
            content: const Text(
              'Do you want to exit an App',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('𝗦𝘂𝗽𝗲𝗿 𝗖𝗵𝗮𝘁'),
        ),
        body: _pageOptions[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 55.0,
          items: <Widget>[
            Icon(
              Icons.chat,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
          ],
          color: Colors.red,
          buttonBackgroundColor: Colors.red,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
