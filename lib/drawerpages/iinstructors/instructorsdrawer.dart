import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/book_a_lesson/lesson_components.dart';
import 'package:s/drawerpages/iinstructors/lessons.dart';

class InstructorsDrawer extends StatefulWidget {
  const InstructorsDrawer({Key? key}) : super(key: key);

  @override
  State<InstructorsDrawer> createState() => _InstructorsDrawerState();
}

class _InstructorsDrawerState extends State<InstructorsDrawer> {
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
                                  "richardoseiwilliams@icloud.com",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "+447496847647",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "+447496847647",
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
                                    Get.to(() => Lessonfromdrawer());
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
