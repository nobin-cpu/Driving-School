import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/book_a_lesson.dart';
import 'package:flutter_html/flutter_html.dart';

import '../login/login.dart';
import '../profile.dart';

class CourseDetails extends StatefulWidget {
  final String image, desc, heading, id, token, totaltime, price;
  final double timelimit;
  const CourseDetails(
      {Key? key,
      required this.image,
      required this.desc,
      required this.heading,
      required this.id,
      required this.token,
      required this.timelimit,
      required this.totaltime,
      required this.price})
      : super(key: key);

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          // IconButton(
          //     onPressed: () {
          //       print(widget.price);
          //     },
          //     icon: Icon(Icons.abc)),
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
                        widget.heading,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Total : " + widget.totaltime + " Hours",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Html(
                        data: widget.desc,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: size.width * .64, bottom: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF198754),
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Get.to(() => BookALesson(
                                price:widget.price,
                                timeLimit: widget.timelimit,
                                token: widget.token,
                                instructorId: "",
                                courseId: widget.id,
                                lat: "",
                                long: "",
                              ));
                        },
                        child: Text("Book Now"),
                      ),
                    ),
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
