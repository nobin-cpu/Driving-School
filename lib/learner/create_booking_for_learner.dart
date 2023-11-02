import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/learner/timeAndDate.dart';
import 'package:s/login/login.dart';
import 'package:s/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class CreateBookingForLearners extends StatefulWidget {
  final String token;
  const CreateBookingForLearners({Key? key, this.token = ""}) : super(key: key);

  @override
  State<CreateBookingForLearners> createState() =>
      _CreateBookingForLearnersState();
}

class Course {
  final int id;

  final String name;
  final int timeLimit;
  final int price;

  Course(this.id, this.name, this.timeLimit, this.price);
}

class _CreateBookingForLearnersState extends State<CreateBookingForLearners> {
  List<Map<String, dynamic>> _learnersList = [];
  String _selectedName = "this";
  int _selectedId = -1;
  int _times = -1;

  List<Map<String, dynamic>> _coursesList = [];
  String _courseName = "";
  int _courseId = -1;

  String haslicence = "";
  String carrequired = "";

  bool? value1 = false;
  bool? value2 = false;

  bool? manual = false;
  bool? automatic = false;

  void provisionLicience() {
    setState(() {
      value1 = !value1!;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchLearners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    // user = usertype.toString();

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.allLearners), headers: requestHeaders);
    if (response.statusCode == 200) {
      print("get it==============");
      print('Get post collected' + response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> learnersData = responseData['data']['learners'];
      return learnersData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Course> _courses = [];
  int? _selectedCourseId;

  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    // user = usertype.toString();

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.courses), headers: requestHeaders);
    if (response.statusCode == 200) {
      print("get it==============");
      print('Get post collected' + response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> coursesData = responseData['data']['courses'];
      final courses = coursesData
          .map<Course>((courseData) => Course(
              courseData['course_id'],
              courseData['headline'],
              courseData['course_hours'],
              courseData['price']))
          .toList();
      setState(() {
        _courses = courses;
      });
      return coursesData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

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

  late Future<List<Map<String, dynamic>>> _learnersFuture;
  late Future<List<Map<String, dynamic>>> _coursesFuture;

  @override
  void initState() {
    _learnersFuture = _fetchLearners();
    _coursesFuture = _fetchCourses();

    print("this is learner" + learnerIdApi.toString());
    print(courseIdApi.toString());
    super.initState();
  }

  String courseIds = "";
  late TextEditingController learnercontroller =
      TextEditingController(text: _selectedName);

  String? learnerIdApi;
  String? courseIdApi;
  int? timeLimits;
  int? prices;
  String? insID;

  Future create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? instIDS = prefs.getString("Instid");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.createCourseLearners),
    );
    request.fields.addAll({
      'learner_id': learnerIdApi.toString(),
      'course_id': courseIdApi.toString(),
      'has_provisional_licence': haslicence.toString(),
      'car_type': carrequired.toString(),
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");
          var data = jsonDecode(response.body);
          // saveprefs(data['data']["user_data"]["type"]);
          print("_______________++++++++++_______success");
          setState(() {
            // _image = null;
            Get.offAll(CreateLearnersTimeandDate(
              courseId: courseIdApi.toString(),
              token: widget.token,
              timeLimit: double.parse(timeLimits.toString()),
              price: prices.toString(),
            ));
            print("_______________++++++++++_______success" + data);
          });
        } else {
          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(
              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
  }

  saveprefs(String intructorIdss) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("insID", intructorIdss);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.token == null ? false : true,
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
                  onTap: () {
                    widget.token != null
                        ? Get.to(() => Profile(
                              token: widget.token,
                            ))
                        : Get.to(() => Logins());
                  },
                  child: const CircleAvatar(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Select Learner",
                  style: TextStyle(fontSize: 23),
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _learnersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Map<String, dynamic>> learnersList =
                        snapshot.data!;
                    final selectedLearner = learnersList.firstWhere(
                        (learner) => learner['id'] == _selectedId,
                        orElse: () => {'name': 'Select a learner'});

                    final selectedCourse = learnersList.firstWhere(
                        (courses) => courses['course_id'] == _courseId,
                        orElse: () => {'name': 'Select a course'});

                    learnerIdApi = selectedLearner['id'].toString();
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Select a learner',
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items:
                                      learnersList.map<DropdownMenuItem<int>>(
                                    (learner) {
                                      return DropdownMenuItem<int>(
                                        value: learner['id'],
                                        child: Text(learner['name']),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedId = value!;
                                      _selectedName = selectedLearner['name'];
                                    });
                                  },
                                  hint: Text(selectedLearner['name']),
                                ),
                              ),
                            ),
                          ),

                          // Text(
                          //   'Selected Name: ${selectedLearner['id']}',
                          //   style: TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Select Course",
                  style: TextStyle(fontSize: 23),
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    print("==========ffaddaadata" + snapshot.data.toString());
                    final List<Map<String, dynamic>> courseList =
                        snapshot.data!;
                    final selectedCourse = courseList.firstWhere(
                        (course) => course['course_id'] == _courseId,
                        orElse: () => {'name': 'Select a course'});

                    courseIdApi = _selectedCourseId.toString();

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Select a course',
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedCourseId,
                                  items: _courses.map<DropdownMenuItem<int>>(
                                    (course) {
                                      return DropdownMenuItem<int>(
                                        value: course.id,
                                        onTap: () {
                                          timeLimits = course.timeLimit;
                                          prices = course.price;
                                        },
                                        child: Text(course.name),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCourseId = value!;
                                    });
                                  },
                                  hint: Text('Select a course'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Text(
                          //   _selectedCourseId.toString(),
                          //   style: TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: [
                    Text(
                      "Does learner have a provisional licence? ",
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
                padding: const EdgeInsets.only(top: 10, left: 10),
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
                                borderRadius: BorderRadius.circular(5)),
                            value: value1,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                value1 = value;
                                value2 = false;
                                value2 == false ? haslicence = "0" : "1";
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
                                borderRadius: BorderRadius.circular(5)),
                            value: value2,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                value1 = false;
                                value2 = value;
                                value1 == false ? haslicence = "1" : "0";
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
                padding: const EdgeInsets.only(top: 10, left: 10),
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
                padding: const EdgeInsets.only(top: 10, left: 10),
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
                              automatic == false ? carrequired = "1" : "2";
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
                              manual == false ? carrequired = "2" : "1";
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
              InkWell(
                onTap: () {
                  create();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
