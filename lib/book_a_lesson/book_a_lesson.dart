import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/lesson_components.dart';

import '../login/login.dart';

class BookALesson extends StatefulWidget {
  const BookALesson({Key? key}) : super(key: key);

  @override
  State<BookALesson> createState() => _BookALessonState();
}

class _BookALessonState extends State<BookALesson> {
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
          children: [Lesson()],
        ),
      ),
    );
  }
}
