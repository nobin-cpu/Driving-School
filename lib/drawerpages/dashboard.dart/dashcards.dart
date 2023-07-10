import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dashcardss extends StatefulWidget {
  const Dashcardss({Key? key}) : super(key: key);

  @override
  State<Dashcardss> createState() => _DashcardssState();
}

class _DashcardssState extends State<Dashcardss> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return 
    Column(
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
                              top: size.height * .03, left: size.width * .06),
                          child: CircleAvatar(
                            maxRadius: size.height * .035,
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: size.height * .04,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .02, left: size.width * .07),
                          child: Text(
                            "Total",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .015, left: size.width * .07),
                          child: Text(
                            "Running Courses",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * .028, left: size.width * .07),
                          child: Text(
                            "1",
                            style: TextStyle(fontSize: 30),
                          ),
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
