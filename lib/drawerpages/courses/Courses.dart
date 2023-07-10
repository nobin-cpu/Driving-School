import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/courses/coursedetails.dart';
import 'package:show_up_animation/show_up_animation.dart';

class DrawerCourses extends StatefulWidget {
  const DrawerCourses({Key? key}) : super(key: key);

  @override
  State<DrawerCourses> createState() => _DrawerCoursesState();
}

class _DrawerCoursesState extends State<DrawerCourses> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                onTap: () {},
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
            ShowUpAnimation(
                delayStart: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 400),
                offset: -0.9,
                curve: Curves.linear,
                direction: Direction.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: size.height * .26,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "images/basic.jpg",
                                      )),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .17,
                                  left: size.width * .05),
                              child: Container(
                                height: size.height * .07,
                                width: size.width * .3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "46 \$",
                                          style: TextStyle(
                                            fontSize: size.height * .03,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "/person",
                                            style: TextStyle(
                                              fontSize: size.height * .027,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            )
                          ]),
                          Container(
                            height: size.height * .3,
                            width: double.infinity,
                            color: Color.fromARGB(18, 76, 175, 79),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "Standard Driving Lessons",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "We'll set you up with the skills and know-how you need to hit the open road like a pro.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Color.fromARGB(90, 0, 0, 0),
                                ),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "THEORY SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("NA")
                                        ],
                                      ),
                                      Container(
                                        height: 49,
                                        width: 1,
                                        color: Color.fromARGB(90, 0, 0, 0),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "PRACTICAL SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("2 Hours")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * .34),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF198754),
                                      ),
                                      onPressed: () {},
                                      child: Text("Active")),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            ShowUpAnimation(
                delayStart: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 400),
                offset: 0.9,
                curve: Curves.linear,
                direction: Direction.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: size.height * .26,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "images/drivr2.jpg",
                                      )),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .17,
                                  left: size.width * .05),
                              child: Container(
                                height: size.height * .07,
                                width: size.width * .3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "55 \$",
                                          style: TextStyle(
                                            fontSize: size.height * .03,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "/person",
                                            style: TextStyle(
                                              fontSize: size.height * .027,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            )
                          ]),
                          Container(
                            height: size.height * .3,
                            width: double.infinity,
                            color: Color.fromARGB(18, 76, 175, 79),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "Intensive Driving Lessons",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "Do you need to get your driving licence quickly? Why not go for our intensive course?",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Color.fromARGB(90, 0, 0, 0),
                                ),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "THEORY SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("NA")
                                        ],
                                      ),
                                      Container(
                                        height: 49,
                                        width: 1,
                                        color: Color.fromARGB(90, 0, 0, 0),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "PRACTICAL SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("2 Hours")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * .34),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF198754),
                                      ),
                                      onPressed: () {},
                                      child: Text("Active")),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            ShowUpAnimation(
                delayStart: Duration(milliseconds: 400),
                animationDuration: Duration(milliseconds: 400),
                offset: 0.9,
                curve: Curves.linear,
                direction: Direction.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(children: [
                            Container(
                              height: size.height * .26,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "images/driv3.jpg",
                                      )),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .17,
                                  left: size.width * .05),
                              child: Container(
                                height: size.height * .07,
                                width: size.width * .3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                      child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "55 \$",
                                          style: TextStyle(
                                            fontSize: size.height * .03,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            "/person",
                                            style: TextStyle(
                                              fontSize: size.height * .027,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ),
                            )
                          ]),
                          Container(
                            height: size.height * .3,
                            width: double.infinity,
                            color: Color.fromARGB(18, 76, 175, 79),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "Block of 40 Hours",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(
                                    "This package is suitable for those with little or no driving experience, 40 hours full package",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Color.fromARGB(90, 0, 0, 0),
                                ),
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "THEORY SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("4 Hours")
                                        ],
                                      ),
                                      Container(
                                        height: 49,
                                        width: 1,
                                        color: Color.fromARGB(90, 0, 0, 0),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: size.height * .03),
                                            child: Text(
                                              "PRACTICAL SESSION",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Text("36 Hours")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: size.width * .34),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF198754),
                                      ),
                                      onPressed: () {},
                                      child: Text("Active")),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
