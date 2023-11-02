import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/drawerpages/dashboard.dart/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../custommizable.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    {
  var token, role, user;
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    user = prefs.getString('type');

    setState(() {});
    print("Hiii" + token);
    print("Hiii" + user);
  }

  @override
  void initState() {
    // TODO: implement initState
    isLoogedIn();

    // Timer(Duration(milliseconds: 200),()=> );
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    // token==null && role==null?introto():token!=null && role=='0'?Naviagate():token!=null && role=='1'?navigateworker():Naviagatelogin();
//  token !=null?role=='1'?navigateworker():role=='0'?Naviagate():Naviagatelogin():Naviagatelogin();
    token != null
        ? Get.to(() => Dashboard(
              token: token,
            ))
        : Get.to(() => CustomizedBottomNavigationbar(
              token: token,
            ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Image.asset("images/logo.png"),
      ),
    );
  }
}
