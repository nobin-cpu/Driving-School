import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/homepage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:s/login/splash.dart';
import 'package:s/privacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../App/appurls.dart';
import '../../book_a_lesson/stripepay.dart';

class Signup extends StatefulWidget {
  String bookingId;
  Signup({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _postalcode = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postal = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordconfirm = TextEditingController();
  bool _ischecked = true;
  bool isLoader = false;
  // Future withdraw() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth_token');

  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     // 'authorization': "Bearer $token"
  //   };
  //   var request = await http.MultipartRequest(
  //     'POST',
  //     Uri.parse(Appurl.signup),
  //   );
  //   request.fields.addAll({
  //     'first_name': _firstname.text,
  //     'last_name': _lastname.text,
  //     'email': _email.text,
  //     'phone': fullPhone.toString(),
  //     'postal_code': _postal.text,
  //     'address': _address.text,
  //     'booking_id': widget.bookingId.toString(),
  //     'password': _password.text,
  //   });

  //   // if (_image != null) {
  //   //   request.files
  //   //       .add(await http.MultipartFile.fromPath('attached_file', _image.path));
  //   // }

  //   request.headers.addAll(requestHeaders);

  //   request.send().then((result) async {
  //     http.Response.fromStream(result).then((response) {
  //       if (response.statusCode == 200) {
  //         var data = jsonDecode(response.body);
  //         print("1234" + data['data']["auth_token"]);
  //         saveprefs(data['data']["auth_token"]);
  //         Get.to(() => SplashScreen());
  //         // titlecontroller.clear();
  //         // messagecontroller.clear();
  //         // saveprefs(data["token"]);
  //         // chat.clear();

  //         // Navigator.push(
  //         //     context,
  //         //     MaterialPageRoute(
  //         //         builder: (context) => HomePage(
  //         //           token: data['data']["auth_token"],
  //         //               isLogin: true,
  //         //             )));
  //         setState(() {});
  //       }
  //       if (response.statusCode == 400) {
  //         var userData1 = jsonDecode(response.body)["message"];
  //         print("======user" + userData1);
  //         Fluttertoast.showToast(
  //             msg: userData1.toString(),
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.BOTTOM,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.red,
  //             textColor: Colors.white,
  //             fontSize: 16.0);
  //         return userData1;
  //       } else {
  //         // print(title);
  //         print(response.body.toString());

  //         return response.body;
  //       }
  //     });
  //   });
  // }

  Future signup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.signup),
    );
    request.fields.addAll({
      'first_name': _firstname.text,
      'last_name': _lastname.text,
      'email': _email.text,
      'phone': fullPhone.toString(),
      'postal_code': _postal.text,
      'address': _address.text,
      'password': _password.text,
      'password_confirmation': _passwordconfirm.text,
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
          print("1234" + data['data']["auth_token"]);
          saveprefs(data['data']["auth_token"]);
          // titlecontroller.clear();
          // messagecontroller.clear();
          // saveprefs(data["token"]);
          // chat.clear();
          Get.to(() => SplashScreen());
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomePage(
          //           token: data['data']["auth_token"],
          //               isLogin: true,
          //             )));

        }
        if (response.statusCode == 400) {
          var userData1 = jsonDecode(response.body)["message"];
          print("======user" + userData1);
          Fluttertoast.showToast(
              msg: userData1.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return userData1;
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
                        controller: _firstname,
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
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
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
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
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
                        controller: _email,
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
                            hintText: 'ex:Johndoe@gmail.com'),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please use valid Mail';
                          }
                          return null;
                        },
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
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
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
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Text(
                          "Password",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
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
                        ),
                        obscureText: true,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordconfirm,
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
                        ),
                        obscureText: true,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Fill The Field';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(_ischecked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            onPressed: () {
                              setState(() {
                                _ischecked = !_ischecked;
                              });
                              print(_ischecked);
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "By creating account, you are agree to our".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              InkWell(
                                child: Text("Privacy policy".tr),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewScreen(
                                          url:
                                              "https://precisiondriving.uk/terms-and-conditions"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      isLoader != true
                          ? Padding(
                              padding: EdgeInsets.only(left: size.width * .35),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF198754),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  if (_form.currentState!.validate()) {
                                    // withdraw();
                                    // Get.back();
                                    signup();
                                    isLoader = true;
                                  }
                                  Future.delayed(Duration(seconds: 4), () {
                                    setState(() {
                                      isLoader = false;
                                    });
                                  });
                                  print(fullPhone);
                                },
                                child: Text("SignUp"),
                              ),
                            )
                          : CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.only(left: 86, top: 30, bottom: 20),
                        child: Row(
                          children: [
                            Text("Already have an account?"),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF198754)),
                              ),
                            ),
                          ],
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
