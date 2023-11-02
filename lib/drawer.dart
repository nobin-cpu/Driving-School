import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/courses/courses.dart';
import 'package:s/drawerpages/bookings/booking.dart';
import 'package:s/drawerpages/bookings/completed/bookings.dart';
import 'package:s/drawerpages/chat/chat.dart';
import 'package:s/drawerpages/courses/Courses.dart';
import 'package:s/drawerpages/dashboard.dart/dashboard.dart';
import 'package:s/drawerpages/upcomingbooking/upcoming_bookings.dart';
import 'package:s/event/event_page.dart';
import 'package:s/learner/all_learners.dart';
import 'package:s/login/splash.dart';
import 'package:s/services/services.dart';
import 'package:s/support/suppport.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:show_up_animation/show_up_animation.dart';

import 'drawerpages/bookings/completed/completed_booking.dart';
import 'drawerpages/iinstructors/Instructordetails.dart';
import 'learner/create_booking_for_learner.dart';
import 'learner/create_learners.dart';

class MyDrawer extends StatefulWidget {
  final String token;
  const MyDrawer({
    super.key,
    required this.token,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = prefs.getString('type') as String;

    setState(() {});
    print("Hiii" + user);
  }

  bool location = false;
  bool service = false;
  bool counter = false;
  bool usertype = false;
  bool users = false;
  bool sms = false;
  bool token = false;
  bool message = false;
  bool learner = false;

  var user = "";

  @override
  void initState() {
    getuser();
    print("-------userssss" + user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
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
                              // print(user);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Get.to(() => Dashboard(
                                  token: widget.token,
                                ));
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
                          title: const Text(
                            "Dashboard",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
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
                              learner = false;
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
                          title: const Text(
                            "Booking",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: const Icon(
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
                                        Get.to(() => Bookings(
                                              token: widget.token,
                                            ));
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Completed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        Get.to(CompletedBookingsScreen(
                                          token: widget.token,
                                        ));
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
                        user == "instructor"
                            ? ListTile(
                                onTap: () {
                                  setState(() {
                                    learner == true
                                        ? learner = false
                                        : learner = true;

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
                                  learner == true
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Learners",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                leading: const Icon(
                                  Icons.person_add_sharp,
                                  color: Colors.white,
                                ), //add icon
                              )
                            : SizedBox(),
                        learner == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: size.width * .15),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Learners",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        Get.to(() => AllLearners());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Create Learners",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        Get.to(() => CreateLearners());
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Create Booking For Learners",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        //action on press
                                        Get.to(() => CreateBookingForLearners(
                                            token: widget.token));
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
                              Get.to(() => Courses(
                                    token: widget.token,
                                    valfordrawer: "0",
                                  ));
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
                              Get.to(() => CalendarPage(
                                    token: widget.token,
                                  ));
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
                            "Calendar",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.calendar_month_outlined,
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
                              Get.to(() => Support(
                                    token: widget.token,
                                  ));
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
                            "Support",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.support_agent,
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
                              Get.to(() => Services(
                                    token: widget.token,
                                    valfordrawer: "0",
                                  ));
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

                        // Container(
                        //     color: Colors.white,
                        //     height: 1,
                        //     width: MediaQuery.of(context).size.width * .7),
                        // ListTile(
                        //   onTap: () {
                        //     Get.to(() => Chatbox(
                        //           email: '',
                        //           image: "",
                        //           name: "",
                        //           phone: "",
                        //           userId: 0,
                        //         ));
                        //     setState(() {
                        //       sms == true ? sms = false : sms = true;

                        //       location = false;
                        //       service = false;
                        //       counter = false;
                        //       usertype = false;
                        //       users = false;
                        //       token = false;
                        //       message = false;
                        //     });
                        //   },

                        //   title: Text(
                        //     "Massanger",
                        //     style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white),
                        //   ),
                        //   leading: Icon(
                        //     Icons.send,
                        //     color: Colors.white,
                        //   ), //add icon
                        // ),

                        // Container(
                        //     color: Colors.white,
                        //     height: 1,
                        //     width: MediaQuery.of(context).size.width * .7),
                        // ListTile(
                        //   onTap: () {
                        //     setState(() {
                        //       token == true ? token = false : token = true;

                        //       location = false;
                        //       service = false;
                        //       counter = false;
                        //       usertype = false;
                        //       sms = false;
                        //       users = false;
                        //       message = false;
                        //     });
                        //   },

                        //   title: Text(
                        //     "Support",
                        //     style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white),
                        //   ),
                        //   leading: Icon(
                        //     Icons.generating_tokens,
                        //     color: Colors.white,
                        //   ), //add icon
                        // ),

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
                              Get.to(() => SplashScreen());
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
