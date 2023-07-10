import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/booktime.dart';
import 'package:s/login/login.dart';

class ChooseInstructor extends StatefulWidget {
  const ChooseInstructor({Key? key}) : super(key: key);

  @override
  State<ChooseInstructor> createState() => _ChooseInstructorState();
}

class _ChooseInstructorState extends State<ChooseInstructor> {
  bool? value1 = false;
  var isSelected = false;
  List<String> name = ["Richard Osei Williams", "Chris Hemsworth", "Jhony Dep"];
  List<String> address = ["15 Lords Avenue", "Dhaka", "California"];
  List<String> temparray = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 158, 158, 158),
      appBar: AppBar(
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
        actions: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Get.to(() => Logins());
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFF198754),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Choose Instructor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: size.height * .03),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.only(top: 8, left: 10, right: 5),
                  child: Text(
                    "Just a few questions to determine the type of lesson or course you would like.",
                    style: TextStyle(fontSize: size.height * .025),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, left: 10, right: 5),
                child: Row(
                  children: [
                    Text(
                      "Instructor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * .025),
                    ),
                    Text(
                      "  *",
                      style: TextStyle(
                          fontSize: size.height * .025,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: name.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected = !isSelected;
                            });
                            if (temparray.contains(
                                // widget.services[index].toString()
                                name[index].toString())) {
                              temparray.remove(name[index].toString());
                            } else {
                              temparray.add(name[index].toString());
                            }
                            if (temparray.contains(
                                // widget.services[index].toString()
                                address[index].toString())) {
                              temparray.remove(address[index].toString());
                            } else {
                              temparray.add(address[index].toString());
                            }
                          },
                          child: Container(
                            height: size.height * .16,
                            decoration: BoxDecoration(
                                color:
                                    temparray.contains(name[index].toString())
                                        ? Color(0xFF198754)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * .025,
                                          left: size.width * .02),
                                      child: Container(
                                        height: size.height * .12,
                                        width: size.width * .22,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            "images/intructor.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * .025),
                                      child: Container(
                                        height: size.height * .12,
                                        width: size.width * .55,
                                        color: temparray.contains(
                                                name[index].toString())
                                            ? Color(0xFF198754)
                                            : Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              child: Text(
                                                name[index].toString(),
                                                style: TextStyle(
                                                    color: temparray.contains(
                                                            name[index]
                                                                .toString())
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Container(
                                              height: 40,
                                              child: Text(
                                                address[index].toString(),
                                                style: TextStyle(
                                                    color: temparray.contains(
                                                            name[index]
                                                                .toString())
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF198754),
        onPressed: () {
          print("thhh" + temparray.toString());
          Get.to(() => TimeandDate());
        },
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
