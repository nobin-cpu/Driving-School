import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/drawer.dart';
import 'package:s/drawerpages/dashboard.dart/dashcards.dart';
import 'package:s/event/event_page.dart';
import 'package:s/profile.dart';

import '../../login/login.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({Key? key, required this.token}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      drawer: MyDrawer(
        token: widget.token,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        toolbarHeight: size.height * .085,
        backgroundColor: Colors.white,
        title: Container(
          height: 100,
          width: 100,
          child: Image.asset(
            "images/logo.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        actions: [
         
          Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  widget.token != null
                      ? Get.to(() => Profile(
                            token: widget.token,
                          ))
                      : Get.to(() => Logins());
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFF198754),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [Dashcardss()],
        ),
      ),
    );
  }
}
