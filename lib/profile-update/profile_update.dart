import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:s/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../App/appurls.dart';
import '../login/login.dart';

class UpdateProfile extends StatefulWidget {
  final name, email, address1, address2, postalCode;
  const UpdateProfile(
      {Key? key,
      this.name,
      this.email,
      this.address1,
      this.address2,
      this.postalCode})
      : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late TextEditingController _usernameController =
      TextEditingController(text: widget.name);
  late TextEditingController _emailController =
      TextEditingController(text: widget.email);
  late TextEditingController _address1Controller =
      TextEditingController(text: widget.address1);
  late TextEditingController _address2Controller =
      TextEditingController(text: widget.address2);
  late TextEditingController _postalController =
      TextEditingController(text: widget.postalCode);

  String? fullPhone;

  ImagePicker picker = ImagePicker();
  var _image, pass;

  Future camera() async {
    XFile? image = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 200, maxWidth: 200);

    setState(() {
      _image = File(image!.path);
      Get.back();
    });

    //return image;
  }

  Future GalleryImage() async {
    XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    setState(() {
      _image = File(image!.path);
      Get.back();
    });
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
      Uri.parse(Appurl.updatebasicInfo),
    );
    request.fields.addAll({
      'name': _usernameController.text,
      'email': _emailController.text,
      'phone': fullPhone.toString(),
      'address_one': _address1Controller.text,
      'address_two': _address2Controller.text,
      'postal_code': _postalController.text,
    });

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', _image.path));
    }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");

          setState(() {
            _image = null;
            Get.offAll(Profile(token: "$token"));
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

  String initialCountry = 'GB';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        automaticallyImplyLeading: true,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Your Name",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _usernameController,
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
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Email Address",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _emailController,
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
                      hintText: 'Email'),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntlPhoneField(
                  initialCountryCode: initialCountry,
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
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(143, 158, 158, 158)),
                    ),
                  ),
                  onChanged: (phones) {
                    print(phones.completeNumber);
                    setState(() {
                      fullPhone = phones.completeNumber;
                    });
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _image != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 90.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.width * .3,
                              child: Image.file(_image),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 28, 28, 28),
                                  content: Container(
                                    color: Color.fromARGB(255, 28, 28, 28),
                                    height: 80,
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              camera();
                                            },
                                            child: Text(
                                              "Take Photo",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              GalleryImage();
                                            },
                                            child: Text(
                                              "Photo Library",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }));
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          color: Colors.black12,
                          child: Center(child: Text("Choose Image")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Your Address",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _address1Controller,
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
                      hintText: 'Address 1'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Your Address",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _address2Controller,
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
                      hintText: 'Address 2'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Postal Code",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _postalController,
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
                      hintText: 'Code'),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  withdraw();
                },
                child: Container(
                  height: 50,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
