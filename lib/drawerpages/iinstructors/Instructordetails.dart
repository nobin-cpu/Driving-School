import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/drawerpages/iinstructors/instructorsdrawer.dart';
import 'package:s/login/login.dart';

class InstructorServics extends StatefulWidget {
  const InstructorServics({Key? key}) : super(key: key);

  @override
  State<InstructorServics> createState() => _InstructorServicsState();
}

class _InstructorServicsState extends State<InstructorServics> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(181, 158, 158, 158),
      appBar: AppBar(
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
                  Get.to(() => Logins());
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
          children: [InstructorsDrawer()],
        ),
      ),
    );
  }
}
