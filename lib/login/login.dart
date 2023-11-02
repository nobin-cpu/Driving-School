import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/homepage.dart';
import 'package:s/login/signUo/signup.dart';
import 'package:s/login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Logins extends StatefulWidget {
  Logins({Key? key}) : super(key: key);

  @override
  State<Logins> createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future withdraw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? user = prefs.getString("type");
    String? instIDS = prefs.getString("Instid");

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.login),
    );
    request.fields.addAll({
      'email': _usernameController.text,
      'password': _passwordController.text,
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
          print("=======" + data['data']["user_data"]["type"]);
          saveprefs(
              data['data']["auth_token"],
              data['data']["user_data"]["type"],
              data['data']["user_data"]["id"].toString());

          // titlecontroller.clear();
          // messagecontroller.clear();
          // saveprefs(data["token"]);
          // chat.clear();
          print("this is instid" + instIDS.toString());
          Get.to(() => SplashScreen());
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => HomePage(
          //           token: data['data']["auth_token"],
          //               isLogin: true,
          //             )));
          setState(() {});
        }
        if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User Credentials Didn't Match"),
            backgroundColor: Color.fromARGB(255, 255, 0, 55),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ));
        } else {
          // print(title);
          print(response.body.toString());

          return response.body;
        }
      });
    });
  }

  saveprefs(String token, user, insID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
    prefs.setString("type", user);
    prefs.setString("Instid", insID);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * .4,
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
                        "Your Email ",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextField(
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
                          hintText: 'Email'),
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
                    TextField(
                      controller: _passwordController,
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
                      obscureText: false,
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * .35),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF198754),
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          print(_passwordController.text);
                          print(_usernameController.text);
                          withdraw();
                          // Get.back();
                        },
                        child: Text("Login"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 86, top: 80),
                      child: Row(
                        children: [
                          Text("Don't have an account?"),
                          InkWell(
                            onTap: () {
                              Get.to(() => Signup(
                                    bookingId: "",
                                  ));
                            },
                            child: Text(
                              "Signup",
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
    );
  }
}
