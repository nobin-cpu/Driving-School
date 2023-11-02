import 'dart:convert';
import 'package:s/book_a_lesson/map.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:s/book_a_lesson/booktime.dart';
import 'package:s/book_a_lesson/choose_instructor.dart';
import 'package:s/login/login.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../App/appurls.dart';
import 'package:flutter_map/src/layer/marker_layer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps;
import 'package:flutter_map/flutter_map.dart' as FlutterMap;

class Lesson extends StatefulWidget {
  String courseId, lat, long, instructorsid, token, price;
  final double timeLimit;
  Lesson({
    Key? key,
    required this.courseId,
    required this.lat,
    required this.long,
    required this.instructorsid,
    required this.token,
    required this.timeLimit,
    required this.price,
  }) : super(key: key);

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  bool? value1 = false;
  bool? value2 = false;
  bool? manual = false;
  bool? automatic = false;
  bool? standard = false;
  bool? intensive = false;
  bool? block = false;
  String haslicence = "";
  String carrequired = "";
  String courseIdfrompage = "";
  double timelimitfrompage = 0.0;
  String latit = "";
  String long = "";

  void provisionLicience() {
    setState(() {
      value1 = !value1!;
    });
  }

  Future withdraw() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.step1),
    );
    request.fields.addAll({
      'has_provisional_licence': haslicence.toString(),
      'car_type': carrequired.toString(),
      'course_id': widget.courseId.toString() != "0"
          ? widget.courseId.toString()
          : courseIdfrompage.toString(),
      'instructor_id': widget.instructorsid.toString() != ""
          ? widget.instructorsid.toString()
          : "",
      'latitude': widget.lat.toString() != ""
          ? widget.lat.toString()
          : latit.toString(),
      'longitude': widget.long.toString() != ""
          ? widget.long.toString()
          : long.toString(),
    });

    // if (_image != null) {
    //   request.files
    //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
    // }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          // titlecontroller.clear();
          // messagecontroller.clear();
          // saveprefs(data["token"]);
          // chat.clear();

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomePage(
          //           token: data['data']["auth_token"],
          //               isLogin: true,
          //             )));
          setState(() {});
        } else {
          // print(title);
          print("12345678");
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  Future homess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.instructors), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post instructor' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      if (userData1 == null) {}
      return userData1;
    }
    if (response.statusCode == 401) {
      print("nobin");
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

  Future<void> _performSearch(String address) async {
    String searchText = _searchController.text;

    try {
      List<Location> locations = await locationFromAddress(searchText);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;
        setState(() {
          latit = latitude.toString();
          long = longitude.toString();
          homes();
        });

        print('Latitude: $latitude');
        print('Longitude: $longitude');
      } else {
        print('No results found for the given place.');
      }
    } catch (e) {
      print('Error searching for the place: $e');
    }
  }

  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            "https://precisiondriving.uk/api/intructor-list?latitude=${latit.toString()}&longitude=${long.toString()}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print("somethinf");
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      if (response.statusCode == 200) {
        Get.to(() => ChooseInstructor(
              price: widget.price,
              timeLimit: widget.timeLimit,
              token: widget.token,
              courseId: widget.courseId.toString() != "0"
                  ? widget.courseId.toString()
                  : courseIdfrompage.toString(),
              instructorId: widget.instructorsid,
              lat: latit.toString(),
              long: long.toString(),
            ));
      }
      return userData1;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No Instructor Is Available At This Address'),
      ));
      print("post have no lat${response.body}");
    }
  }

  Future courses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.courses), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  GoogleMapController? _mapController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future? home1;
  Future? home2;
  Future? coursess;

  @override
  void initState() {
    coursess = courses();

    home2 = homess();
    requestLocationPermission();
    super.initState();
  }

  late GoogleMapController myController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  int? selectedIndex;

  MapController mapController = MapController();
  // List<Marker> markers = [];
  // LatLng sourcelocation = LatLng(28.432864, 77.002563);
  CameraPosition initialcameraposition = CameraPosition(
    zoom: 11,
    bearing: 30,
    target: LatLng(37.7749, -122.4194),
  );
  Future<void> requestLocationPermission() async {
    if (await Permission.location.isGranted) {
      // You can use the location now.
    } else {
      // Request the permission.
      await Permission.location.request();
    }
  }

  List<String> selectedItems = [];
  String selectedItem = "";
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        widget.token == null
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: size.height * .17,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * .06),
                          child: Container(
                            height: size.height * .14,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Are You An Exciting Customer!!!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  "Click Below To Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF198754),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Get.to(() => Logins());
                                    },
                                    child: Text("Log In")),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(maxHeight: double.infinity),
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * .06, top: size.height * .02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The fundamentals",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Just a few questions to determine the type of lesson or course you would like.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Do you have a provisional licence? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  provisionLicience();
                                  print(haslicence);
                                  setState(() {
                                    value1 == true ? haslicence = "1" : "2";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      value: value1,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          value1 = value;
                                          value2 = false;
                                          value2 == false
                                              ? haslicence = "1"
                                              : "2";
                                          print(haslicence.toString());
                                        });
                                      },
                                    ),
                                    Text("Yes")
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // value2 == true ? haslicence = "2" : "1";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      value: value2,
                                      activeColor: Colors.blue,
                                      onChanged: (value) {
                                        setState(() {
                                          value1 = false;
                                          value2 = value;
                                          value1 == false
                                              ? haslicence = "2"
                                              : "1";
                                          print(haslicence.toString());
                                        });
                                      },
                                    ),
                                    Text("No")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Car type required ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: manual,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = value;
                                        automatic = false;
                                        automatic == false
                                            ? carrequired = "1"
                                            : "2";
                                        print(carrequired.toString());
                                      });
                                    },
                                  ),
                                  Text("Manual")
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: automatic,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = false;
                                        automatic = value;
                                        manual == false
                                            ? carrequired = "2"
                                            : "1";
                                        print(carrequired.toString());
                                      });
                                    },
                                  ),
                                  Text("Automatic")
                                ],
                              ),
                            ],
                          ),
                        ),
                        widget.courseId == '0'
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Course Type",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " *",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: coursess,
                                          builder: (_,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: buildShimmerEffect(),
                                              );
                                            } else if (snapshot.hasData) {
                                              return ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data["courses"].length,
                                                itemBuilder: (context, index) {
                                                  return ShowUpAnimation(
                                                    delayStart: Duration(
                                                        milliseconds: 400),
                                                    animationDuration: Duration(
                                                        milliseconds: 400),
                                                    offset: 0.9,
                                                    curve: Curves.linear,
                                                    direction:
                                                        Direction.horizontal,
                                                    child: Card(
                                                      child: ListTile(
                                                          leading: Icon(
                                                            Icons.circle,
                                                            color:
                                                                selectedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                          tileColor:
                                                              selectedIndex ==
                                                                      index
                                                                  ? Color(
                                                                      0xFF198754)
                                                                  : null,
                                                          onTap: () {
                                                            setState(() {
                                                              courseIdfrompage = snapshot
                                                                  .data[
                                                                      "courses"]
                                                                      [index][
                                                                      "course_id"]
                                                                  .toString();
                                                              selectedIndex =
                                                                  index;
                                                              selectedItem = snapshot
                                                                  .data[
                                                                      "courses"]
                                                                      [index][
                                                                      "headline"]
                                                                  .toString();
                                                            });
                                                            timelimitfrompage =
                                                                double.parse(snapshot
                                                                    .data[
                                                                        "courses"]
                                                                        [index][
                                                                        "course_hours"]
                                                                    .toString());
                                                            print("---------" +
                                                                timelimitfrompage
                                                                    .toString());
                                                          },
                                                          title: Text(snapshot
                                                              .data["courses"]
                                                                  [index]
                                                                  ["headline"]
                                                              .toString())),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return Image.asset(
                                                "images/no-data.gif",
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        widget.courseId != '0'
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Select Location",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      " *",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.courseId != '0'
                                  ? TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Search location',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            String searchAddress =
                                                _searchController.text;
                                            _performSearch(searchAddress);
                                            _performSearch(searchAddress);

                                            withdraw();

                                            homess();

                                            // _showSearchDialog();
                                            widget.courseId == "0"
                                                ? Get.to(() => TimeandDate(
                                                      price: widget.price,
                                                      token: widget.token,
                                                      timeLimit:
                                                          timelimitfrompage,
                                                      courseId: widget.courseId
                                                                  .toString() !=
                                                              "0"
                                                          ? widget.courseId
                                                              .toString()
                                                          : courseIdfrompage
                                                              .toString(),
                                                      instructorId:
                                                          widget.instructorsid,
                                                    ))
                                                : SizedBox();
                                          },
                                        ),
                                      ))
                                  : SizedBox(),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * .6, top: 16, bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    String searchAddress =
                                        _searchController.text;
                                    _performSearch(searchAddress);
                                    _performSearch(searchAddress);

                                    withdraw();

                                    homess();

                                    // _showSearchDialog();
                                    widget.courseId == "0"
                                        ? Get.to(() => TimeandDate(
                                              price: widget.price,
                                              token: widget.token,
                                              timeLimit: timelimitfrompage,
                                              courseId: widget.courseId
                                                          .toString() !=
                                                      "0"
                                                  ? widget.courseId.toString()
                                                  : courseIdfrompage.toString(),
                                              instructorId:
                                                  widget.instructorsid,
                                            ))
                                        : SizedBox();

                                    print("============" +
                                        widget.courseId.toString());
                                    print("hiii" + long.toString());
                                  },
                                  child: Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // widget.courseId != "0"
                        //     ? Padding(
                        //         padding: const EdgeInsets.only(
                        //             top: 10, right: 15, bottom: 10),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Container(
                        //               height: 500,
                        //               child: Maps(),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Future<void> _showSearchDialog() async {
  //   String address = 'Dhaka';
  //   address = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Search Location'),
  //         content: TextField(
  //           decoration: InputDecoration(hintText: 'Enter an address'),
  //           onSubmitted: (value) {
  //             Navigator.of(context).pop(value);
  //           },
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('Search'),
  //             onPressed: () {
  //               Navigator.of(context).pop(address);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (address != null && address.isNotEmpty) {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       Location location = locations.first;
  //       mapController.move(
  //         LatLng(location.latitude, location.longitude),
  //         13.0,
  //       );
  //       setState(() {
  //         markers.clear();
  //         markers.add(
  //           Marker(
  //             width: 30.0,
  //             height: 30.0,
  //             point: LatLng(location.latitude, location.longitude),
  //             builder: (ctx) => Icon(Icons.location_on, color: Colors.red),
  //           ),
  //         );
  //       });
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Location Not Found'),
  //             content: Text('No results found for the provided address.'),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

}
