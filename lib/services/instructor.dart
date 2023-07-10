import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/book_a_lesson.dart';

class Instructors extends StatefulWidget {
  const Instructors({Key? key}) : super(key: key);

  @override
  State<Instructors> createState() => _InstructorsState();
}

class _InstructorsState extends State<Instructors> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: size.height * .3,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          height: size.height * .17,
                          width: size.width * .28,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/intructor.jpg"))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Spacer(),
                        Container(
                          height: size.height * .24,
                          width: size.width * .62,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Richard Osei Williams",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "15 Lords Avenue",
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "Richard is an exceptional driving instructor known for his unparalleled expertise, unwavering patience, and genuine passion for teaching. Richard's approach to instruction is characterized by his ability to create a relaxed and supportive learning environment. He understands that each student possesses unique strengths and",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF198754),
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    Get.to(() => BookALesson());
                                  },
                                  child: Text("Book Now"))
                            ],
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
