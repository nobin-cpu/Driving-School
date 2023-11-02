import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/book_a_lesson.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:s/profile.dart';

import '../drawer.dart';
import '../login/login.dart';

class InstructorDetails extends StatefulWidget {
  String valfordrawer;
  final String image, name, email, id, number, address, lat, long, token;
   InstructorDetails(
      {Key? key,
      required this.image,
      required this.name,
      required this.address,
      required this.email,
      required this.number,
      required this.id,
      required this.lat,
      required this.long,
      required this.valfordrawer, required this.token})
      : super(key: key);

  @override
  State<InstructorDetails> createState() => _InstructorDetailsState();
}

class _InstructorDetailsState extends State<InstructorDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       drawer: widget.valfordrawer == "0" ? MyDrawer(token: widget.token,) : null,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxHeight: double.infinity),
                color: Color.fromARGB(18, 76, 175, 79),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * .3,
                      width: double.infinity,
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.name,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Email: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            widget.email,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Phone: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            widget.number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Address: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            widget.address,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * .64),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF198754),
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Get.to(() => BookALesson(
                            price: "",
                            timeLimit: 0,
                            token: widget.token,
                                instructorId: widget.id,
                                courseId: "0",
                                lat: widget.lat,
                                long: widget.long,
                              ));
                        },
                        child: Text("Book Now"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
