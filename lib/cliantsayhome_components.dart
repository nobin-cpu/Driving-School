import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:s/App/appurls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CliantSays extends StatefulWidget {
  const CliantSays({Key? key}) : super(key: key);

  @override
  State<CliantSays> createState() => _CliantSaysState();
}

class _CliantSaysState extends State<CliantSays> {
  Future homes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(Appurl.homescarous), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)["data"];

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: 400.0,
        color: Colors.white,
      ),
    );
  }

  Future? home1;
  @override
  void initState() {
    home1 = homes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * .65,
          child: FutureBuilder(
            future: home1,
            builder: (_, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: buildShimmerEffect(),
                );
              } else if (snapshot.hasData) {
                return CarouselSlider.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(240, 25, 135, 84),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.height * .0,
                                  top: size.height * .03,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    snapshot.data["testimonials"][index]
                                        ["avatar"],
                                    height: size.height * .25,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.height * .03,
                                    top: size.height * .022,
                                    right: 10),
                                child: Text(
                                  snapshot.data["testimonials"][index]
                                      ["speech"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 7,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: size.height * .2,
                                  top: size.height * .022,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data["testimonials"][index]
                                          ["name"],
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      snapshot.data["testimonials"][index]
                                          ["designation"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },

                  //Slider Container properties
                  options: CarouselOptions(
                    height: size.height * .6,
                    scrollPhysics: BouncingScrollPhysics(),
                    autoPlay: true,
                  ),
                );
              } else {
                return Text("No productt found");
              }
            },
          ),
        ),
      ],
    );
  }
}
