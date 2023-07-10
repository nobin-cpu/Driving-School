import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Chatbox extends StatefulWidget {
  final int userId;
  final String image, name, email, phone;
  const Chatbox(
      {super.key,
      required this.userId,
      required this.image,
      required this.name,
      required this.email,
      required this.phone});

  @override
  State<Chatbox> createState() => _ChatboxState();
}

class _ChatboxState extends State<Chatbox> {
  var pickimage;
  final TextEditingController chat = TextEditingController();

  ImagePicker picker = ImagePicker();
  var _image, pass;
  Future camera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
      Get.back();
    });

    //return image;
  }

  Future GalleryImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
      Get.back();
    });
  }

  // Future viewOffers() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth-token');

  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };

  //   var response = await http.get(
  //       Uri.parse(Appurl.smslist + widget.userId.toString()),
  //       headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     print('Get post collected' + response.body);
  //     var userData1 = jsonDecode(response.body)["data"];

  //     return userData1;
  //   } else {
  //     print("post have no Data${response.body}");
  //   }
  // }

  // Future withdraw() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth-token');

  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };
  //   var request = await http.MultipartRequest(
  //     'POST',
  //     Uri.parse(Appurl.chatist),
  //   );
  //   request.fields.addAll({
  //     'message': chat.text,
  //     'to_user': widget.userId.toString(),
  //   });

  //   if (_image != null) {
  //     request.files
  //         .add(await http.MultipartFile.fromPath('attached_file', _image.path));
  //   }

  //   request.headers.addAll(requestHeaders);

  //   request.send().then((result) async {
  //     http.Response.fromStream(result).then((response) {
  //       if (response.statusCode == 200) {
  //         print("massge sent");
  //         chat.clear();

  //         setState(() {
  //           sms = viewOffers();
  //           _image = null;
  //         });
  //       } else {
  //         print("Fail! ");
  //         print(response.body.toString());
  //         // Fluttertoast.showToast(
  //         //     msg: "Error Occured",
  //         //     toastLength: Toast.LENGTH_LONG,
  //         //     gravity: ToastGravity.BOTTOM,
  //         //     timeInSecForIosWeb: 1,
  //         //     backgroundColor: Colors.red,
  //         //     textColor: Colors.white,
  //         //     fontSize: 16.0);
  //         return response.body;
  //       }
  //     });
  //   });
  // }

//location
  Future? sms;
  Future? sendsmss;
  @override
  void initState() {
    // sms = viewOffers();

    print(" this is user" + widget.userId.toString());
    super.initState();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF198754),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 0, 50, 90),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .30,
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .06,
                                              backgroundImage: NetworkImage(
                                                widget.image,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                            widget.name,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            widget.email,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            widget.phone,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.info))
            ],
            leadingWidth: MediaQuery.of(context).size.height * .09,
            leading: SizedBox(
              height: 10,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(
                      widget.image,
                    )),
              ),
            ),
            title: Text(
              widget.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: sms,
                builder: (_, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      reverse: true,
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(child:
                              LayoutBuilder(builder: (context, constraints) {
                            if (snapshot.data[index]["is_file"] == 1) {
                              return Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .35,
                                    width:
                                        MediaQuery.of(context).size.width * .90,
                                    child: Row(
                                      mainAxisAlignment: snapshot.data[index]
                                                  ["userId"] ==
                                              widget.userId.toString()
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            // Appurl.baseURL +
                                            //     snapshot.data[index]["message"],
                                            "images/bg.png", fit: BoxFit.cover,
                                            width: 200,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index]["time"],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 47, 47, 47),
                                        fontSize: 13),
                                  ),
                                ],
                              );
                            }

                            if (snapshot.data[index]["is_file"] != 1) {
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: snapshot.data[index]
                                                  ["userId"] ==
                                              widget.userId.toString()
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        snapshot.data[index]["userId"] ==
                                                widget.userId.toString()
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          color: Colors.blue),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                ["message"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ["time"],
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 47, 47, 47),
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          color: Color.fromARGB(
                                                              255,
                                                              119,
                                                              119,
                                                              119)),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                ["message"],
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data[index]
                                                          ["time"],
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 47, 47, 47),
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Text("");
                            }
                          }));
                        },
                      ),
                    );
                  } else {
                    return Text("No productt found");
                  }
                },
              ),
            ),
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
            Container(
              height: 65,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 237, 237, 237),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: MediaQuery.of(context).size.height * .01),
                child: Container(
                    height: MediaQuery.of(context).size.height * .04,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextField(
                            controller: chat,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              // labelText: 'Type Here...',
                              hintText: 'Type Here...',
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
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
                            icon: Icon(Icons.link)),
                        IconButton(
                            onPressed: () {
                              // withdraw();
                              clearimage() {
                                setState(() {
                                  _image = null;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.blue,
                            ))
                      ],
                    )),
              ),
            )
          ],
        ));
  }
}
