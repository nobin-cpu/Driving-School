import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:s/learner/all_learners.dart';
import 'package:s/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../App/appurls.dart';
import '../login/login.dart';

class CreateLearners extends StatefulWidget {
  const CreateLearners({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateLearners> createState() => _CreateLearnersState();
}

class _CreateLearnersState extends State<CreateLearners> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _address1Controller = TextEditingController();
  late TextEditingController _password = TextEditingController();
  late TextEditingController _confirmPassword = TextEditingController();

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

  TextEditingController _searchController = TextEditingController();
  String latit = "";
  String long = "";

  Future<void> _performSearch(String address) async {
    String searchText = address.toString();

    try {
      List<Location> locations = await locationFromAddress(searchText);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;
        setState(() {
          latit = latitude.toString();
          long = longitude.toString();
          withdraw();
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

  Future withdraw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.createLearners),
    );
    request.fields.addAll({
      'name': _usernameController.text,
      'email': _emailController.text,
      'phone': fullPhone.toString(),
      'location': _address1Controller.text,
      'password': _password.text,
      'latitude': latit.toString(),
      'longitude': long.toString(),
    });

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image.path));
    }

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("massge sent");

          setState(() {
            _image = null;
            Get.offAll(AllLearners());
            print("_______________++++++++++_______");
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
                  "Learners Name",
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
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Learners Phone",
                  style: TextStyle(fontSize: 20),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Learners Image",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
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
                  "Learners Address",
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
                      hintText: 'Address '),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Password",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _password,
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
                      hintText: 'Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 10),
                child: Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _confirmPassword,
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
                      hintText: 'Password'),
                ),
              ),
              SizedBox(height: 20.0),
              InkWell(
                onTap: () {
                  _performSearch(_address1Controller.text);
                  print(_address1Controller.text);
                },
                child: Container(
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
        ),
      ),
    );
  }
}
