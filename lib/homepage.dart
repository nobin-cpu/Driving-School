import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:s/carousal_for_home.dart';
import 'package:s/cliantsayhome_components.dart';
import 'package:s/courses/courses.dart';
import 'package:s/drawer.dart';
import 'package:s/homecomponents.dart';
import 'package:s/login/login.dart';
import 'package:s/playgrond.dart';
import 'package:s/services/services.dart';
import 'component_for_about.dart';

class HomePage extends StatefulWidget {
  String token;
  bool isLogin = true;
  HomePage({Key? key, required this.isLogin, required this.token})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  // bool isLogin = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 10), () {
      print("i am ready");
      widget.isLogin = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: widget.token != null ? MyDrawer() : null,
      appBar: AppBar(
        automaticallyImplyLeading: widget.token == null ? false : true,
        iconTheme: IconThemeData(color: Colors.green),
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
          children: [
            HomeComponents(),
            SizedBox(
              height: 30,
            ),
            Carous(),
            About(),
            CliantSays()
          ],
        ),
      ),
    );
  }
}
