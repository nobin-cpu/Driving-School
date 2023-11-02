import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:s/homepage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:s/login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../App/appurls.dart';
import '../../book_a_lesson/stripepay.dart';

class Signupfrombook extends StatefulWidget {
  String bookingId, price;
  Signupfrombook({Key? key, required this.bookingId, required this.price})
      : super(key: key);

  @override
  State<Signupfrombook> createState() => _SignupfrombookState();
}

class _SignupfrombookState extends State<Signupfrombook> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _emailaddress = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postal = TextEditingController();
  bool isLoader = false;
  Future withdraw() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.step3),
    );
    request.fields.addAll({
      'first_name': _usernameController.text,
      'last_name': _lastname.text,
      'email': _emailaddress.text,
      'phone': fullPhone.toString(),
      'postal_code': _postal.text,
      'address': _address.text,
      'password': _passwordController.text,
      'password_confirmation': _passwordController2.text,
      'booking_id': widget.bookingId.toString(),
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
          Get.to(() => StripePaymentPage(price: widget.price));
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
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  saveprefs(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  final _form = GlobalKey<FormState>();
  String? fullPhone;
  String initialCountry = 'GB';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                height: size.height * .3,
                width: double.infinity,
                color: Colors.black,
                child: Image.asset(
                  "images/vectr.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16, top: size.height * .04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Text(
                          "First Name",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                            hintText: 'ex:John'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Text(
                          "Last Name",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _lastname,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                            hintText: 'ex:Doe'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Text(
                          "Email Address",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _emailaddress,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please use valid Mail';
                          }
                          return null;
                        },
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
                            hintText: 'ex:Johndoe@gmail.com'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      IntlPhoneField(
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
                            borderSide: BorderSide(
                                color: Color.fromARGB(143, 158, 158, 158)),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Text(
                          "Address",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _address,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                            hintText:
                                'ex:Great Russell St, Bloomsbury, London'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8,
                        ),
                        child: Text(
                          "Postal Code",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _postal,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                            hintText: 'ex:1234'),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Text(
                          "Password ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Text(
                          "Confirm Password ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController2,
                        style: TextStyle(fontSize: 20),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please fill the field';
                          }
                          return null;
                        },
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
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * .35),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF198754),
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              withdraw();
                              isLoader = true;
                            }

                            // print(_phone.text);
                            // Get.back();
                            print(fullPhone.toString());
                          },
                          child: Text("Next"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
