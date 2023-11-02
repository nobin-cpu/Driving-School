import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TicketCreation extends StatefulWidget {
  const TicketCreation({Key? key}) : super(key: key);

  @override
  State<TicketCreation> createState() => _TicketCreationState();
}

class _TicketCreationState extends State<TicketCreation> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool? low = false;
  bool? medium = false;
  bool? high = false;
  bool? criticle = false;

  String? priority = "0";

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
      Uri.parse(Appurl.createTicket),
    );
    request.fields.addAll({
      'subject': subjectController.text,
      'description': descriptionController.text,
      'priority': priority.toString(),
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
            Get.back();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8, left: 10),
              child: Text(
                "Ticket  Subject",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: subjectController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color(0xFF198754),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF198754),
                      ),
                    ),
                    hintText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 8, left: 10),
              child: Text(
                "Ticket  Description",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10,
                controller: descriptionController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color(0xFF198754),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF198754),
                      ),
                    ),
                    hintText: 'Description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: [
                  Text(
                    "Please select priority level ",
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
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        low == true ? priority = "0" : "0";
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: low,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              low = value;
                              medium = false;
                              high = false;
                              criticle = false;
                              low == true ? priority = "0" : "0";
                              print(priority.toString());
                            });
                          },
                        ),
                        Text("Low")
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        medium == true ? priority = "1" : "0";
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: medium,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              medium = value;
                              low = false;
                              high = false;
                              criticle = false;
                              medium == true ? priority = "1" : "0";
                              print(priority.toString());
                            });
                          },
                        ),
                        Text("Medium")
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        high == true ? priority = "2" : "0";
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: high,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              high = value;
                              medium = false;
                              low = false;
                              criticle = false;
                              high == true ? priority = "2" : "0";
                              print(priority.toString());
                            });
                          },
                        ),
                        Text("High")
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        criticle == true ? priority = "2" : "0";
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: criticle,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              criticle = value;
                              medium = false;
                              low = false;
                              high = false;
                              criticle == true ? priority = "3" : "0";
                              print(priority.toString());
                            });
                          },
                        ),
                        Text("Criticle")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, primary: Color(0xFF198754)),
                  onPressed: () {
                    create();
                  },
                  child: const Center(
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
