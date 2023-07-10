import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/homepage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _emailaddress = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String fullPhone = '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                          hintText: 'ex:Richard'),
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
                    TextField(
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
                          hintText: 'ex:William'),
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
                    TextField(
                      controller: _emailaddress,
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
                    TextField(
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
                          hintText: 'ex:15 Lord Avenue'),
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
                    TextField(
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
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * .35),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF198754),
                            textStyle: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          // Get.to(() => HomePage(
                          //       isLogin: true,
                          //     ));
                          Get.back();
                        },
                        child: Text("SignUp"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 86, top: 80, bottom: 20),
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
    );
  }
}
