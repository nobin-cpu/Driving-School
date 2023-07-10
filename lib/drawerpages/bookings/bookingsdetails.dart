import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Bookingsdetails extends StatefulWidget {
  const Bookingsdetails({Key? key}) : super(key: key);

  @override
  State<Bookingsdetails> createState() => _BookingsdetailsState();
}

class _BookingsdetailsState extends State<Bookingsdetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * .3,
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .03, left: size.width * .07),
                          child: Text("18-Jun-2023 10:06 AM"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .02, left: size.width * .07),
                          child: Row(
                            children: [
                              Text(
                                "Instructor :",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " Richard Osei Williams",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .003, left: size.width * .07),
                          child: Row(
                            children: [
                              Text(
                                "Email :",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "richardoseiwilliams@icloud.com",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .02, left: size.width * .07),
                          child: Row(
                            children: [
                              Text(
                                "Learner :",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " Yanke saheh",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .003, left: size.width * .07),
                          child: Row(
                            children: [
                              Text(
                                "Email :",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "learner@test.com",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: size.width * .7, top: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF198754),
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {},
                              child: Text("Details")),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }))
      ],
    );
  }
}
