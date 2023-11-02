import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:s/App/appurls.dart';
import 'package:s/drawer.dart';
import 'package:s/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../drawerpages/bookings/booking_details.dart';
import '../profile.dart';

class CalendarEvent {
  int id;
  String title;
  DateTime start;
  String instructorName;
  String learnerName;
  String courseTitle;
  String hasprobitionallyc;
  String carType;
  String courseHour;
  String price;
  String timeLimit;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.instructorName,
    required this.learnerName,
    required this.courseTitle,
    required this.hasprobitionallyc,
    required this.carType,
    required this.courseHour,
    required this.price,
    required this.timeLimit,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    final event = json['event'];
    final instructor = json['instructor'];
    final learner = json['learner'];
    final course = json['course'];
    final hasprobitional = json["has_provisional_licence"];
    final car_types = json["car_type"];
    final courseHour = json["course"];
    final prices = json["has_provisional_licence"];

    return CalendarEvent(
      id: event['booking_id'],
      hasprobitionallyc: hasprobitional,
      title: event['title'],
      start: DateTime.parse(event['start']),
      instructorName: instructor['name'],
      learnerName: learner['name'],
      courseTitle: course['title'],
      carType: car_types,
      courseHour: courseHour['course_hours'].toString(),
      price: courseHour['price'].toString(),
      timeLimit: courseHour['course_hours'].toString(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  final String token;

  const CalendarPage({super.key, required this.token});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? usertype = prefs.getString('type');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.events), headers: requestHeaders);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final eventsData = jsonResponse['data'];
      List<CalendarEvent> fetchedEvents = List<CalendarEvent>.from(
        eventsData.map((eventData) => CalendarEvent.fromJson(eventData)),
      );
      setState(() {
        _events = fetchedEvents;
      });
    } else {
      print('API call failed with status code: ${response.statusCode}');
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return event.start.year == day.year &&
          event.start.month == day.month &&
          event.start.day == day.day;
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });

    List<CalendarEvent> selectedDayEvents = _getEventsForDay(selectedDay);

    if (selectedDayEvents.isNotEmpty) {
      _showEventPopup(selectedDayEvents);
    }
  }

  void _showEventPopup(List<CalendarEvent> events) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Events for selected day'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: events
                  .map((event) => SizedBox(
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            _showEventDetails(
                                event); // Show detailed information for the selected event
                          },
                          child: Card(
                              margin: EdgeInsets.all(10),
                              color: Colors.green,
                              child: Center(
                                child: Text(
                                  event.title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEventDetails(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Time: ${event.title}'),
              SizedBox(
                height: 10,
              ),
              Text('Date: ${DateFormat('yyyy-MM-dd').format(event.start)}'),
              SizedBox(
                height: 10,
              ),
              Text('Instructor: ${event.instructorName}'),
              SizedBox(
                height: 10,
              ),
              Text('Learner: ${event.learnerName}'),
              SizedBox(
                height: 10,
              ),
              Text('Course: ${event.courseTitle}'),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(
                      OngoingBookingDetails(
                        bokingId: event.id.toString(),
                        carType: event.carType,
                        courseHour: int.parse(event.courseHour),
                        haslicence: event.hasprobitionallyc,
                        instructorId: event.instructorName,
                        price: int.parse(event.price),
                        title: event.title,
                        timeLimit: int.parse(event.timeLimit),
                      ),
                    );
                    print(event.hasprobitionallyc);
                  },
                  child: Center(
                    child: Text("Booking Details"),
                  ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(
        token: widget.token,
      ),
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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2023, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
          ),
        ],
      ),
    );
  }
}
