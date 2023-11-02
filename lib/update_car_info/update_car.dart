import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateCarInfo extends StatefulWidget {
  const UpdateCarInfo({Key? key}) : super(key: key);

  @override
  State<UpdateCarInfo> createState() => _UpdateCarInfoState();
}

class _UpdateCarInfoState extends State<UpdateCarInfo> {
  bool? manual = false;
  bool? automatic = false;
  List<String> carrequired = [];
  String carrequireds = "";
  TextEditingController _manualcarModelController = TextEditingController();
  TextEditingController _autocarModelController = TextEditingController();
  TextEditingController manualCarRegController = TextEditingController();
  TextEditingController autoCarRegController = TextEditingController();
  Future carInfoUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.carinfoUpdate),
    );
    request.fields.addAll({
      'car_type': carrequired.toString(),
      'manual_car_model': _manualcarModelController.text,
      'manual_car_registration': manualCarRegController.text,
      'auto_car_registration': autoCarRegController.text,
      'auto_car_model': _autocarModelController.text,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");

          setState(() {
            Get.offAll(Profile(token: "$token"));
            carrequired.clear();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      " * Select Car type",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
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
                            manual = manual!;
                            manual == true
                                ? carrequired.add("1")
                                : carrequired.remove("1");
                            // automatic = false;
                            // automatic == false ? carrequireds = "2" : "1";
                            // automatic == false ? carrequired = ["2"] : ["1"];
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
                            // manual = false;
                            // automatic = value;
                            // manual == false ? carrequireds = "2" : "1";
                            // manual == false ? carrequired = ["2"] : ["1"];

                            automatic = value;
                            automatic = automatic!;
                            automatic == true
                                ? carrequired.add("2")
                                : carrequired.remove("2");
                            print(carrequired);
                          });
                        },
                      ),
                      Text("Automatic")
                    ],
                  ),
                ],
              ),
            ),
            // carrequireds != "2"
            //     ?
            manual == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 10),
                        child: Text(
                          "* Enter Manual Car Model",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _manualcarModelController,
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
                              hintText: 'Model'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 10),
                        child: Text(
                          "Manual car REG. No.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: manualCarRegController,
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
                              hintText: 'Car REG. Number'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  )
                : SizedBox(),

            automatic == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 10),
                        child: Text(
                          "* Enter Automatic Car Model",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _autocarModelController,
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
                              hintText: 'Model'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, left: 10),
                        child: Text(
                          "Automatic car REG. No.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: autoCarRegController,
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
                              hintText: 'Car REG. Number'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  carInfoUpdates();
                  print(carrequired.toString());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text("Save Change",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.white))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
