import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../profile.dart';
import 'multiday.dart';

class TimeAndScheduleChange extends StatefulWidget {
  final double timeLimit;
  const TimeAndScheduleChange({Key? key, this.timeLimit = 0.0})
      : super(key: key);

  @override
  State<TimeAndScheduleChange> createState() => _TimeAndScheduleChangeState();
}

class _TimeAndScheduleChangeState extends State<TimeAndScheduleChange> {
  List<String> addtimes = [];
  List<String> addtimes2 = [];
  List<String> addtime = [];

  List<double> numbers = [];
  double sum = 0;
  double test = 0;
  String item = "";
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

  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(Appurl.availavleTimes),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
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

  Future? home1;
  @override
  void initState() {
    home1 = homes();
    super.initState();
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _selectedTime2 = TimeOfDay.now();

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime1 = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime1 != null && pickedTime1 != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime1;
        _from.text = _formatSelectedTime();
      });
    }
  }

  String _formatSelectedTime() {
    if (_selectedTime == null) {
      return '';
    }

    String hour = _selectedTime.hour.toString().padLeft(2, '0');
    String minute = _selectedTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _selectTime2() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime2,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime2 = pickedTime;
        _to.text = _formatSelectedTime2();
      });
    }
  }

  String _formatSelectedTime2() {
    if (_selectedTime2 == null) {
      return '';
    }

    String hour = _selectedTime2.hour.toString().padLeft(2, '0');
    String minute = _selectedTime2.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _from = TextEditingController();
  TextEditingController _to = TextEditingController();
  List<String> _selectedDays = [];

  final List<String> _daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> _selectDays(BuildContext context) async {
    List<bool> isSelected = List.generate(
        _daysList.length, (index) => _selectedDays.contains(_daysList[index]));

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Days'),
          content: MultiSelectChip(
            daysList: _daysList,
            isSelected: isSelected,
            onSelectionChanged: (List<bool> selected) {
              setState(() {
                isSelected = selected;
                _selectedDays.clear();
                for (int i = 0; i < isSelected.length; i++) {
                  if (isSelected[i]) {
                    _selectedDays.add(_daysList[i]);
                  }
                }
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Done'),
            ),
          ],
        );
      },
    );

    _controller.text = _formatSelectedDays();
  }

  String _formatSelectedDays() {
    return _selectedDays.join(" , ");
  }

  Future withdraw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.timeScheduleUpdate),
    );
    request.fields.addAll({
      'weekends': _selectedDays.toString(),
      'from_time': _from.text,
      'to_time': _to.text,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");
          print(response.body.toString());
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TimeAndScheduleChange()),
            );
            // Navigator.pop(context, true);
            // Get.offAll(() => TimeAndScheduleChange());
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

  void _refreshPage() {
    setState(() {
      homes();
    });
  }

  void addNumber(double number) {
    setState(() {
      numbers.add(number);
      sum += number;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
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
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: size.height * .03, left: 20, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Times",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: home1,
                    builder: (_, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: buildShimmerEffect(),
                        );
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data["time"].length,
                              itemBuilder: (context, index) {
                                bool isSelected = addtime.contains(item);
                                var id = snapshot.data["time"][index]["id"]
                                    .toString();
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
                                          tileColor: addtimes.contains(snapshot
                                                  .data["time"][index]["id"]
                                                  .toString())
                                              ? Color(0xFF198754)
                                              : Colors.white,
                                          onTap: () {
                                            setState(() {
                                              if (addtime.contains(snapshot
                                                  .data["time"][index]
                                                      ["timeInHours"]
                                                  .toString())) {
                                                addtime.remove(snapshot
                                                    .data["time"][index]
                                                        ["timeInHours"]
                                                    .toString());
                                              } else {
                                                addtime.add(snapshot
                                                    .data["time"][index]
                                                        ["timeInHours"]
                                                    .toString());
                                              }

                                              if (addtimes.contains(
                                                  // widget.services[index].toString()
                                                  snapshot.data["time"][index]
                                                          ["id"]
                                                      .toString())) {
                                                addtimes.remove(snapshot
                                                    .data["time"][index]["id"]
                                                    .toString());
                                                _removeNumber(double.parse(
                                                    snapshot.data["time"][index]
                                                            ["timeInHours"]
                                                        .toString()));
                                              } else {
                                                sum != widget.timeLimit
                                                    ? addtimes.add(snapshot
                                                        .data["time"][index]
                                                            ["id"]
                                                        .toString())
                                                    : ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Cannot add more items.Time limit is reached.'),
                                                      ));
                                                sum != widget.timeLimit
                                                    ? addNumber(double.parse(
                                                        snapshot.data["time"]
                                                                [index]
                                                                ["timeInHours"]
                                                            .toString()))
                                                    : "";
                                                addtimes2
                                                    .add(addtimes.toString());
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
                                                        .data["time"][index]
                                                            ["start_time"]
                                                        .toString() +
                                                    "--" +
                                                    snapshot.data["time"][index]
                                                            ["end_time"]
                                                        .toString()),
                                              ),
                                            ),
                                          ),
                                          trailing: Text(snapshot.data["time"]
                                                      [index]["in_hours"]
                                                  .toString() +
                                              " Hours"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: size.height * .03),
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From Time",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              readOnly: true, // To prevent manual text input
                              onTap: () => _selectTime(),
                              controller: TextEditingController(
                                text: _selectedTime.format(context),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Select Time',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "To Time",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              readOnly: true, // To prevent manual text input
                              onTap: () => _selectTime2(),
                              controller: TextEditingController(
                                text: _selectedTime2.format(context),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Select Time',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => _selectDays(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Select Days',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                )),
            InkWell(
              onTap: () {
                print(_to.text);
                withdraw();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: 200,
                child: Center(
                    child: Text(
                  "Done",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> daysList;
  final List<bool> isSelected;
  final Function(List<bool>) onSelectionChanged;

  MultiSelectChip({
    required this.daysList,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: List<Widget>.generate(widget.daysList.length, (int index) {
        return FilterChip(
          label: Text(widget.daysList[index]),
          selected: widget.isSelected[index],
          onSelected: (bool selected) {
            setState(() {
              widget.isSelected[index] = selected;
              widget.onSelectionChanged(widget.isSelected);
            });
          },
        );
      }).toList(),
    );
  }
}
