import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:s/faq.dart/faqview.dart';
import 'package:s/login/login.dart';

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
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
          child: Column(
            children: [FaqComp()],
          ),
        ),
      ),
    );
  }
}
