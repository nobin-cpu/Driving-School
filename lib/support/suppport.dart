import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s/login/login.dart';
import 'package:s/profile.dart';

import 'widgets/create_ticket.dart';

class Support extends StatefulWidget {
  final String token;
  const Support({Key? key, required this.token}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                child: const CircleAvatar(
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
          children: [CreateTicket()],
        ),
      ),
    );
  }
}
