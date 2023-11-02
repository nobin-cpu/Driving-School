import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/login/login.dart';
import 'package:s/login/splash.dart';
import 'package:s/pasword_update/passsword_update.dart';
import 'package:s/privacy.dart';
import 'package:s/profile-update/profile_update.dart';
import 'package:s/profile-update/update_bio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'schedule_time_select_or_change.dart/schedule_time.dart';
import 'update_car_info/update_car.dart';

class Profile extends StatefulWidget {
  String token;
  Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 400.0,
        color: Colors.white,
      ),
    );
  }

  Future destroy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('user-id');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer ${widget.token}"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.deleteaccount),
    );
    // request.fields.addAll({
    //   'otp': pin,
    //   'phone': widget.number,
    // });

    // if (_image != null) {
    //   request.files
    //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
    // }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print("massge sent");

          // chat.clear();
          Get.off(SplashScreen());
          setState(() {});
        } else {
          print("Fail! ");

          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  String name = "";
  String email = "";
  String address1 = "";
  String address2 = "";
  String postalCodde = "";

  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.profile), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];
      name = userData1["name"];
      email = userData1["email"];
      address1 = userData1["location"];
      address2 = userData1["city"];
      postalCodde = userData1["postal_code"];
      return userData1;
    }
    if (response.statusCode == 401) {
      _showPopUp();
    } else {
      print("post have no Data${response.body}");
    }
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text('To continue go to login page'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: Text('Ok'),
              onPressed: () {
                Get.to(() => Logins());
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController smscontroller = TextEditingController();

  Future withdraw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.help),
    );
    request.fields.addAll({
      'subject': titlecontroller.text,
      'message': smscontroller.text,
    });

    // if (_image != null) {
    //   request.files
    //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
    // }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          titlecontroller.clear();
          smscontroller.clear();
          var data = jsonDecode(response.body);
          print(titlecontroller.text);
          // saveprefs(data["token"]);
          // chat.clear();
          Get.back();
          setState(() {});
        }
        if (response.statusCode == 400) {
          print("===nobin");
        } else {
          print(response.body.toString());
          // Fluttertoast.showToast(
          //     msg: "Error Occured",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  Future? home1;
  @override
  void initState() {
    home1 = homes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         print(widget.token);
          //       },
          //       icon: Icon(Icons.abc))
          // ],
          iconTheme: IconThemeData(color: Colors.green),
          automaticallyImplyLeading: true,
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
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: home1,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: buildShimmerEffect(),
                );
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(height: 50),
                    Container(
                      height: size.height * .15,
                      width: double.infinity,
                      child: Center(
                        child: Stack(children: [
                          CircleAvatar(
                            radius: size.height * .07,
                            backgroundImage: NetworkImage(
                              snapshot.data["avatar"],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 70, left: 85),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.white,
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      Get.to(() => UpdateProfile(
                                            name: name,
                                            email: email,
                                            address1: address1,
                                            address2: address2,
                                            postalCode: postalCodde,
                                          ));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Text(
                      snapshot.data["name"],
                      style: TextStyle(fontSize: size.height * .04),
                    ),
                    Text(
                      snapshot.data["email"],
                      style: TextStyle(fontSize: size.height * .02),
                    ),
                    SizedBox(
                      height: size.height * .07,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          snapshot.data["user_type"] == "instructor"
                              ? InkWell(
                                  onTap: () {
                                    Get.to(() => UpdateCarInfo());
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: size.height * .04,
                                        color: Colors.green,
                                      ),
                                      snapshot.data["user_type"] == "instructor"
                                          ? SizedBox(
                                              width: 20,
                                            )
                                          : SizedBox(),
                                      Text(
                                        "Update Car Info.",
                                        style: TextStyle(
                                            fontSize: size.height * .03),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          snapshot.data["user_type"] == "instructor"
                              ? SizedBox(
                                  height: size.height * .01,
                                )
                              : SizedBox(),
                          snapshot.data["user_type"] == "instructor"
                              ? Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Colors.green,
                                )
                              : SizedBox(),
                          // snapshot.data["user_type"] == "instructor"
                          //     ? SizedBox(
                          //         height: size.height * .01,
                          //       )
                          //     : SizedBox(),
                          // snapshot.data["user_type"] == "instructor"
                          //     ? InkWell(
                          //         onTap: () {
                          //           Get.to(() => TimeAndScheduleChange());
                          //         },
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.punch_clock_outlined,
                          //               size: size.height * .04,
                          //               color: Colors.green,
                          //             ),
                          //             SizedBox(
                          //               width: 20,
                          //             ),
                          //             Text(
                          //               "Update Time Schedule",
                          //               style: TextStyle(
                          //                   fontSize: size.height * .03),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     : SizedBox(),
                          // snapshot.data["user_type"] == "instructor"
                          //     ? SizedBox(
                          //         height: size.height * .01,
                          //       )
                          //     : SizedBox(),
                          // Container(
                          //   height: 1,
                          //   width: double.infinity,
                          //   color: Colors.green,
                          // ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => UpdateBio());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.border_color_outlined,
                                  size: size.height * .04,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Update Bio",
                                  style: TextStyle(fontSize: size.height * .03),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => Update_password());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: size.height * .04,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Update Password",
                                  style: TextStyle(fontSize: size.height * .03),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    url:
                                        "https://precisiondriving.uk/privacy-policy", // Replace with your desired URL
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  size: size.height * .04,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Privacy-policy",
                                  style: TextStyle(fontSize: size.height * .03),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          InkWell(
                            onTap: () async {
                              // Get.to(() => Displaysettings());

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 0, 95, 3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Are you sure you wants to delete your account?"
                                                      .tr,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .02),
                                                    child: InkWell(
                                                      onTap: () {
                                                        destroy();
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .06,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .1,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "YES".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .02),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          height:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .06,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .08,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "NO".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: size.height * .04,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Delete Account",
                                  style: TextStyle(fontSize: size.height * .03),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                backgroundColor: Colors.transparent,
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Help and Support".tr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          SizedBox(height: 8),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Title'.tr,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextFormField(
                                            maxLength: 556,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 6,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Message'.tr,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    125,
                                                                    145))),
                                                hintText: "Message here"),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                              onPressed: () {
                                                withdraw();
                                              },
                                              child: Text("Send"))
                                        ],
                                      ),
                                    )),
                                isDismissible: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                enableDrag: false,
                              );
                            },
                            child: InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  backgroundColor: Colors.transparent,
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Help and Support".tr,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(height: 8),
                                            TextFormField(
                                              controller: titlecontroller,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Title'.tr,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              controller: smscontroller,
                                              maxLength: 556,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 6,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Message'.tr,
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .grey)),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  errorBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      66,
                                                                      125,
                                                                      145))),
                                                  hintText: "Message here"),
                                            ),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: 200,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    withdraw();
                                                    print("send".tr);
                                                  },
                                                  child: Text("Send".tr)),
                                            )
                                          ],
                                        ),
                                      )),
                                  isDismissible: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  enableDrag: false,
                                );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .01,
                                  ),
                                  Icon(
                                    Icons.settings,
                                    color: Colors.green,
                                    size: size.height * .04,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .04,
                                  ),
                                  Text(
                                    "Help and Support".tr,
                                    style:
                                        TextStyle(fontSize: size.height * .03),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          InkWell(
                            onTap: () async {
                              // Get.to(() => LogInPage());
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('auth_token');
                              Get.to(() => SplashScreen());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout_outlined,
                                  size: size.height * .04,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Logout",
                                  style: TextStyle(fontSize: size.height * .03),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Image.asset(
                  "images/no-data.gif",
                );
              }
            },
          ),
        ));
  }
}
