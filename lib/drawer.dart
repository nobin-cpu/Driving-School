import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/drawerpages/bookings/booking.dart';
import 'package:s/drawerpages/chat/chat.dart';
import 'package:s/drawerpages/courses/Courses.dart';
import 'package:s/drawerpages/dashboard.dart/dashboard.dart';
import 'package:s/drawerpages/upcomingbooking/upcoming_bookings.dart';
import 'package:s/login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:show_up_animation/show_up_animation.dart';

import 'drawerpages/iinstructors/Instructordetails.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool location = false;
  bool service = false;
  bool counter = false;
  bool usertype = false;
  bool users = false;
  bool sms = false;
  bool token = false;
  bool message = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        backgroundColor: Color(0xFF198754),
        child: SingleChildScrollView(
          child: Theme(
            data:
                Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .09,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "images/logo.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // ListTile(
                        //   title: InkWell(
                        //     onTap: () {
                        //       // Get.to(Homepage());
                        //     },
                        //     child: Text(
                        //       "Dashboard",
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white),
                        //     ),
                        //   ),
                        //   leading: Icon(
                        //     Icons.dashboard,
                        //     color: Colors.white,
                        //   ), //add icon
                        //   //children padding
                        // ),
                        // Container(
                        //     color: Colors.white,
                        //     height: 1,
                        //     width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            Get.to(() => Dashboard());
                            setState(() {
                              location == true
                                  ? location = false
                                  : location = true;

                              service = false;
                              counter = false;
                              usertype = false;
                              users = false;
                              sms = false;
                              token = false;
                              message = false;
                            });
                          },
                          title: Text(
                            "Dashboard",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          // trailing: Icon(
                          //   location == true
                          //       ? Icons.expand_less
                          //       : Icons.expand_more,
                          //   color: Colors.white,
                          // ),
                          leading: Icon(
                            Icons.home,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            setState(() {
                              service == true
                                  ? service = false
                                  : service = true;

                              location = false;
                              counter = false;
                              usertype = false;
                              users = false;
                              sms = false;
                              token = false;
                              message = false;
                            });
                          },
                          trailing: Icon(
                            service == true
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Booking",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.workspaces,
                            color: Colors.white,
                          ), //add icon
                        ),
                        service == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: size.width * .15),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Ongoing",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        Get.to(() => Bookings());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Completed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        // Get.to(Sectionlist());
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            setState(() {
                              Get.to(() => DrawerCourses());
                              counter == true
                                  ? counter = false
                                  : counter = true;

                              location = false;
                              service = false;
                              usertype = false;
                              users = false;
                              sms = false;
                              token = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Courses",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.list_alt_rounded,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            setState(() {
                              Get.to(() => InstructorServics());
                              usertype == true
                                  ? usertype = false
                                  : usertype = true;

                              location = false;
                              service = false;
                              counter = false;
                              users = false;
                              sms = false;
                              token = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Instructors",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.person_search_sharp,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            setState(() {
                              Get.to(() => UpcomingBooking());
                              users == true ? users = false : users = true;

                              location = false;
                              service = false;
                              counter = false;
                              usertype = false;
                              sms = false;
                              token = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Bookings",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            Get.to(() => Chatbox(
                                  email: '',
                                  image: "",
                                  name: "",
                                  phone: "",
                                  userId: 0,
                                ));
                            setState(() {
                              sms == true ? sms = false : sms = true;

                              location = false;
                              service = false;
                              counter = false;
                              usertype = false;
                              users = false;
                              token = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Massanger",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.send,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () {
                            setState(() {
                              token == true ? token = false : token = true;

                              location = false;
                              service = false;
                              counter = false;
                              usertype = false;
                              sms = false;
                              users = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Support",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.generating_tokens,
                            color: Colors.white,
                          ), //add icon
                        ),

                        Container(
                            color: Colors.white,
                            height: 1,
                            width: MediaQuery.of(context).size.width * .7),
                        ListTile(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('auth_token');
                            setState(() {
                              Get.to(()=>SplashScreen());
                              sms == true ? sms = false : sms = true;

                              location = false;
                              service = false;
                              counter = false;
                              usertype = false;
                              users = false;
                              token = false;
                              message = false;
                            });
                          },

                          title: Text(
                            "Log Out",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ), //add icon
                        ),

                        // Container(
                        //     color: Colors.white,
                        //     height: 1,
                        //     width: MediaQuery.of(context).size.width * .7),
                        // ExpansionTile(
                        //   title: Text(
                        //     "Display",
                        //     style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white),
                        //   ),
                        //   leading: Icon(
                        //     Icons.desktop_windows,
                        //     color: Colors.white,
                        //   ), //add icon
                        //   childrenPadding:
                        //       EdgeInsets.only(left: 60), //children padding
                        //   children: [
                        //     ListTile(
                        //       title: Text(
                        //         "Single line queue",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       onTap: () {
                        //         //action on press
                        //       },
                        //     ),
                        //     ListTile(
                        //       title: Text(
                        //         "Counter wise queue 1",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       onTap: () {
                        //         //action on press
                        //       },
                        //     ),
                        //     ListTile(
                        //       title: Text(
                        //         "Counter wise queue 2",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       onTap: () {
                        //         //action on press
                        //       },
                        //     ),
                        //     ListTile(
                        //       title: Text(
                        //         "Location wise queue",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       onTap: () {
                        //         //action on press
                        //       },
                        //     ),

                        //     //more child menu
                        //   ],
                        // ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
