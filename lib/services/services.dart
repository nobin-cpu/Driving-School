import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/drawer.dart';
import 'package:s/login/login.dart';
import 'package:s/services/instructor.dart';

import '../profile.dart';

class Services extends StatefulWidget {
  String valfordrawer, token;

  Services({Key? key, required this.valfordrawer, required this.token})
      : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        widget.valfordrawer != "0" ? SystemNavigator.pop() : Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(181, 158, 158, 158),
        drawer: widget.valfordrawer == "0"
            ? MyDrawer(
                token: widget.token,
              )
            : null,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.green),
          automaticallyImplyLeading: widget.valfordrawer == "0" ? true : false,
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
          child: Column(
            children: [
              Instructors(
                token: widget.token,
              )
            ],
          ),
        ),
      ),
    );
  }
}
