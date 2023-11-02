import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:s/profile.dart';
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
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        drawer: widget.token != null
            ? MyDrawer(
                token: widget.token,
              )
            : null,
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
                    widget.token != null
                        ? Get.to(() => Profile(
                              token: widget.token,
                            ))
                        : Get.to(() => Logins());
                  },
                  child:const CircleAvatar(
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
              HomeComponents(
                token: widget.token,
              ),
              SizedBox(
                height: size.height * .1,
              ),
              Carous(token: widget.token),
              SizedBox(
                height: size.height * .1,
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * .5),
                child: SizedBox(
                  child: Text(
                    "Why with us?",
                    style: TextStyle(
                        fontSize: 26,
                        color: Color(0xFF198754),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              About(token: widget.token),
              SizedBox(
                height: size.height * .08,
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * .5),
                child: SizedBox(
                  child: Text(
                    "Testimonials",
                    style: TextStyle(
                        fontSize: 26,
                        color: Color(0xFF198754),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CliantSays()
            ],
          ),
        ),
      ),
    );
  }
}
