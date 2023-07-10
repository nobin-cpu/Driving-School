import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../login/login.dart';

class TimeandDate extends StatefulWidget {
  const TimeandDate({Key? key}) : super(key: key);

  @override
  State<TimeandDate> createState() => _TimeandDateState();
}

class _TimeandDateState extends State<TimeandDate> {
  String _selectedItem = '';
  List<String> _dropdownItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

  TextEditingController _dateTimeController = TextEditingController();
  DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd');
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
      });
    }
  }

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
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: _selectedItem),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: DropdownButton<String>(
                                value: _selectedItem,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem = newValue!;
                                    Navigator.pop(context);
                                  });
                                },
                                items: _dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
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
          print("thhh" + _dateTimeController.text);
          // Get.to(() => TimeandDate());
        },
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
