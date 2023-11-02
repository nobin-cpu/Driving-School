import 'dart:convert';
import 'package:s/App/appurls.dart';
import 'package:s/login/login.dart';
import 'package:s/profile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangeSchedule extends StatefulWidget {
  String instructorId, courseId, token, price;
  double timeLimit;
  ChangeSchedule(
      {Key? key,
      required this.instructorId,
      required this.courseId,
      this.timeLimit = 0.0,
      required this.token,
      required this.price})
      : super(key: key);

  @override
  State<ChangeSchedule> createState() => _ChangeScheduleState();
}

class _ChangeScheduleState extends State<ChangeSchedule> {
  String _selectedItem = '';
  String courseIdfrompage = "";

  String selectedItem = "";
  int? selectedIndex;
  List<String> _dropdownItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];
  List<String> addtimes = [];
  List<String> addtimes2 = [];
  List<String> addtime = [];
  List<double> values = [];
  List<bool> isSelected = [];
  TextEditingController _dateTimeController = TextEditingController();
  DateFormat _dateTimeFormat = DateFormat('dd-MM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateTimeController.text = _dateTimeFormat.format(picked);

        sentDate();
        getTimeList();
        _removeItem();
      });
    }
  }

  List<String> dataList = [];
  Future updateSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    // Convert the list of strings to a list of integers
    List<int> selectedTimes = addtimes.map((time) => int.parse(time)).toList();

    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.updateschedule),
    );

    request.fields.addAll({
      'booking_id': widget.courseId.toString(),
      'selected_date': _dateTimeController.text,
    });

    // Send the list of integers directly as 'selected_times' without JSON encoding
    for (int time in selectedTimes) {
      request.fields['selected_times[]'] = time.toString();
    }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var data = jsonDecode(response.body);
          setState(() {
            addtimes.clear();
            if (sum == widget.timeLimit) {
              if (widget.token == null) {
                Get.offAll(ChangeSchedule(
                  instructorId: widget.instructorId,
                  courseId: widget.courseId,
                  token: widget.token,
                  price: widget.price,
                  timeLimit: widget.timeLimit,
                ));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'You Need To Select More Times To Fulfill Course Time'),
              ));
            }
          });
        } else {
          print(response.body.toString());
          return response.body;
        }
      });
    });
  }

  Future sentDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.sentDate),
    );
    request.fields.addAll({
      'booking_id': widget.courseId.toString(),
      'instructor_id': widget.instructorId.toString(),
      'date': _dateTimeController.text,
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

          setState(() {
            home3 = getTimeList();
          });
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

        } else {
          // print(title);
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  Future getTimeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            "https://precisiondriving.uk/api/available-time/update?booking_id=${widget.courseId}&date=${_dateTimeController.text}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected here' + response.body);
      print("1234");
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    }
    if (response.statusCode == 401) {
      _showPopUp();
    } else {
      print("12345");
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

  Future? home3;
  @override
  void initState() {
    home3 = getTimeList();

    _dateTimeController.text != null ? getTimeList() : null;
    super.initState();
  }

  bool isvisible = false;
  String item = "";
  List<double> numbers = [];
  double sum = 0;
  double test = 0;
  void addNumber(double number) {
    setState(() {
      numbers.add(number);
      sum += number;
    });
  }

  void _removeNumber(double number) {
    setState(() {
      numbers.remove(number);
      sum -= number;
    });
  }

  void _removeItem() {
    setState(() {
      addtimes.clear();
    });
  }

  var id;
  @override
  Widget build(BuildContext context) {
    // int sum = addtime.fold(
    //     0, (previousValue, element) => previousValue + int.parse(element));
    // if (addtime.isNotEmpty) {
    //   int sum = addtime.map((str) => int.parse(str)).reduce((a, b) => a + b);
    //   String sums = sum.toString();
    //   print('Sum: $sum');
    // } else {
    //   print('List is empty.');
    // }

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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Date ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "*",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _dateTimeController,
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xFF198754),
                          )),
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          labelText: 'Select Date',
                          labelStyle: TextStyle(
                            color: Color(0xFF198754),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Time",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "*",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: home3,
                      builder: (_, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: buildShimmerEffect(),
                          );
                        } else if (snapshot.hasData) {
                          return Column(
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data["times"].length,
                                itemBuilder: (context, index) {
                                  bool isSelected = addtime.contains(item);

                                  print("hellow ");
                                  return ShowUpAnimation(
                                    delayStart: Duration(milliseconds: 400),
                                    animationDuration:
                                        Duration(milliseconds: 400),
                                    offset: 0.9,
                                    curve: Curves.linear,
                                    direction: Direction.horizontal,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                              tileColor: addtimes.contains(
                                                      snapshot.data["times"]
                                                              [index]["id"]
                                                          .toString())
                                                  ? Color(0xFF198754)
                                                  : Colors.white,
                                              onTap: () {
                                                setState(() {
                                                  if (addtime.contains(widget
                                                      .timeLimit
                                                      .toString())) {
                                                    addtime.remove(widget
                                                        .timeLimit
                                                        .toString());
                                                  } else {
                                                    addtime.add(widget.timeLimit
                                                        .toString());
                                                  }

                                                  if (addtimes.contains(
                                                      // widget.services[index].toString()
                                                      snapshot.data["times"]
                                                              [index]["id"]
                                                          .toString())) {
                                                    addtimes.remove(snapshot
                                                        .data["times"][index]
                                                            ["id"]
                                                        .toString());
                                                    _removeNumber(double.parse(
                                                        widget.timeLimit
                                                            .toString()));
                                                  } else {
                                                    sum != widget.timeLimit
                                                        ? addtimes.add(snapshot
                                                            .data["times"]
                                                                [index]["id"]
                                                            .toString())
                                                        : ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                            content: Text(
                                                                'Cannot add more items.Time limit is reached.'),
                                                          ));
                                                    sum != widget.timeLimit
                                                        ? addNumber(
                                                            double.parse(widget
                                                                .timeLimit
                                                                .toString()))
                                                        : "";
                                                    addtimes2.add(
                                                        addtimes.toString());
                                                  }
                                                });
                                                // List<int> number =
                                                //     int.parse(addtime.toString())
                                                //         as List<int>;

                                                ;
                                              },
                                              title: Card(
                                                child: SizedBox(
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(snapshot
                                                            .data["times"]
                                                                [index]
                                                                ["start_from"]
                                                            .toString() +
                                                        "--" +
                                                        snapshot.data["times"]
                                                                [index]
                                                                ["to_end"]
                                                            .toString()),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * .03),
                                child: Text(
                                  "Total times" + sum.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text("00");
                        }
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF198754),
        onPressed: () {
          setState(() {
            isvisible = true;
          });
          print("hello+++++++++++++" + addtimes.toString());
          updateSchedule();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
