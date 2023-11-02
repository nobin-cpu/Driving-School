import 'package:flutter/material.dart';
import 'package:s/courses/courses.dart';
import 'package:s/faq.dart/faq.dart';
import 'package:s/homepage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:s/services/services.dart';

class CustomizedBottomNavigationbar extends StatefulWidget {
  String token = "";
  CustomizedBottomNavigationbar({Key? key, required this.token})
      : super(key: key);

  @override
  _CustomizedBottomNavigationbarState createState() =>
      _CustomizedBottomNavigationbarState();
}

class _CustomizedBottomNavigationbarState
    extends State<CustomizedBottomNavigationbar> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodySection(),
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }

// * Body Section Components
  bodySection() {
    switch (index) {
      case 0:
        return Courses(
          token: widget.token,
          valfordrawer: "1",
        );
      case 1:
        return HomePage(
          token: widget.token,
          isLogin: false,
        );
      case 2:
        return Services(
          token: widget.token,
          valfordrawer: "1",
        );
      // case 3:
      //   return Faq();
    }
  }

// * BottomNavigationBar Section Components
  customBottomNavigationBar() {
    return BottomNavyBar(
      selectedIndex: index,
      items: [
        BottomNavyBarItem(
            icon: Icon(
              Icons.drive_eta,
              size: 30,
            ),
            title: Text('COURSES'),
            inactiveColor: Colors.black,
            activeColor: Color(0xFF198754),
            textAlign: TextAlign.center),
        BottomNavyBarItem(
          icon: Icon(
            Icons.apps,
            size: 30,
          ),
          title: Text(
            'HOME',
          ),
          inactiveColor: Colors.black,
          activeColor: Color(0xFF198754),
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
            icon: Icon(
              Icons.school,
              size: 30,
            ),
            title: FittedBox(fit: BoxFit.cover, child: Text('INSTRUCTORS')),
            inactiveColor: Colors.black,
            activeColor: Color(0xFF198754),
            textAlign: TextAlign.center),
        // BottomNavyBarItem(
        //     icon: Icon(
        //       Icons.help,
        //       size: 30,
        //     ),
        //     title: Text('CONTACTS'),
        //     inactiveColor: Colors.black,
        //     activeColor: Color(0xFF198754),
        //     textAlign: TextAlign.center),
      ],
      onItemSelected: (index) => setState(() => this.index = index),
    );
  }
}
