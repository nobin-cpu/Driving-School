import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FaqComp extends StatefulWidget {
  const FaqComp({Key? key}) : super(key: key);

  @override
  State<FaqComp> createState() => _FaqCompState();
}

class _FaqCompState extends State<FaqComp> {
  bool newsExpanded = false;
  bool weatherExpanded = false;

  List listTiles = ["A", "B", "C", "Footer"];
  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: ((context, index) {
              return ExpansionTile(
                  title: Text(
                    "How Much Are Driving Lessons",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Driving lessons vary in cost depending on where you live.",
                      ),
                    )
                  ],
                  onExpansionChanged: (onChanged) {
                    if (onChanged) {
                      setState(() {
                        newsExpanded = false;
                        weatherExpanded = true;
                      });
                    }
                  });
            }))
      ],
    );
  }
}
