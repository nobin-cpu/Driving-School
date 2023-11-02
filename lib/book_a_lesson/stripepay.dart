import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:s/App/appurls.dart';
import 'package:s/login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../login/login.dart';

class StripePaymentPage extends StatefulWidget {
  final String price;

  const StripePaymentPage({super.key, required this.price});
  @override
  State<StripePaymentPage> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  final TextEditingController cardname = TextEditingController();
  final TextEditingController paymentgateway = TextEditingController();
  final TextEditingController cvc = TextEditingController();
  final TextEditingController exyear = TextEditingController();
  final TextEditingController exmonth = TextEditingController();
  late TextEditingController _textEditingController =
      TextEditingController(text: widget.price);
  final TextEditingController cardnumber = TextEditingController();
  String paymentname = "stripe";
  String def = "";
  Future withdraw() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      // 'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(Appurl.stripepay),
    );
    request.fields.addAll({
      'payment_gateway': paymentname.toString(),
      'card_number': cardnumber.text,
      'expiration_month': exmonth.text,
      'amount': _textEditingController.text,
      'expiration_year': exyear.text,
      'cvc': cvc.text,
      'name_on_card': cardname.text,
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
          Get.to(() => SplashScreen());
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
        }
        if (response.statusCode == 403) {
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
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Something Went wrong'),
          // ));
          print(response.body.toString());

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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.green),
        toolbarHeight: size.height * .085,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //     onPressed: () {
        //       print(widget.price);
        //     },
        //     icon: Icon(Icons.abc)),
        title: Container(
          height: 100,
          width: 100,
          child: Image.asset(
            "images/logo.png",
            fit: BoxFit.fitWidth,
          ),
        ),
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.all(10.0),
        //       child: InkWell(
        //         onTap: () {
        //          widget.token != null
        //                 ? Get.to(() => Profile(
        //                       token: widget.token,
        //                     ))
        //                 : Get.to(() => Logins());
        //         },
        //         child: CircleAvatar(
        //           backgroundColor: Color(0xFF198754),
        //           child: Icon(
        //             Icons.person,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Name',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: cardname,
                        decoration: InputDecoration(
                          hintText: 'Enter card Name',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Card Number',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: cardnumber,
                        decoration: InputDecoration(
                          hintText: 'Enter card number',
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Month',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  controller: exmonth,
                                  decoration: InputDecoration(
                                    hintText: 'MM',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiry Year',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  controller: exyear,
                                  decoration: InputDecoration(
                                    hintText: 'yy',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CVC',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  controller: cvc,
                                  decoration: InputDecoration(
                                    hintText: '123',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                TextField(
                                  readOnly: true,
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                    hintText: '12345',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              RaisedButton(
                onPressed: () {
                  withdraw();
                  // Process payment logic
                },
                color: Color(0xFF198754),
                textColor: Colors.white,
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
