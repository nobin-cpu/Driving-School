import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:s/book_a_lesson/choose_instructor.dart';
import 'package:s/login/login.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class Lesson extends StatefulWidget {
  const Lesson({Key? key}) : super(key: key);

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  bool? value1 = false;
  bool? value2 = false;
  bool? manual = false;
  bool? automatic = false;
  bool? standard = false;
  bool? intensive = false;
  bool? block = false;

  final TextEditingController _searchController = TextEditingController();
  MapController mapController = MapController();
  // List<Marker> markers = [];
  // LatLng sourcelocation = LatLng(28.432864, 77.002563);
  CameraPosition initialcameraposition = CameraPosition(
    zoom: 20,
    tilt: 80,
    bearing: 30,
    target: LatLng(28.432864, 77.002563),
  );
  void _performSearch() async {
    String searchText = _searchController.text;

    try {
      List<Location> locations = await locationFromAddress(searchText);

      if (locations.isNotEmpty) {
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;

        print('Latitude: $latitude');
        print('Longitude: $longitude');
      } else {
        print('No results found for the given place.');
      }
    } catch (e) {
      print('Error searching for the place: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: size.height * .17,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * .06),
                    child: Container(
                      height: size.height * .14,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Are You An Exciting Customer!!!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "Click Below To Login",
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF198754),
                                  textStyle:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Get.to(() => Logins());
                              },
                              child: Text("Log In"))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            constraints: BoxConstraints(maxHeight: double.infinity),
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * .06, top: size.height * .02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The fundamentals",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Just a few questions to determine the type of lesson or course you would like.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Do you have a provisional licence? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: value1,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        value1 = value;
                                        value2 = false;
                                      });
                                    },
                                  ),
                                  Text("Yes")
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: value2,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        value1 = false;
                                        value2 = value;
                                      });
                                    },
                                  ),
                                  Text("No")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Car type required ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: manual,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = value;
                                        automatic = false;
                                      });
                                    },
                                  ),
                                  Text("Manual")
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: automatic,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = false;
                                        automatic = value;
                                      });
                                    },
                                  ),
                                  Text("Automatic")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Course Type",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: manual,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = value;
                                        automatic = false;
                                      });
                                    },
                                  ),
                                  Text("Standard Driving Lessons")
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: automatic,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = false;
                                        automatic = value;
                                      });
                                    },
                                  ),
                                  Text("Intensive Driving Lessons")
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: automatic,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        manual = false;
                                        automatic = value;
                                      });
                                    },
                                  ),
                                  Text("Block of 40 Hours ")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Select Location",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                " *",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: 'Enter A Location',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * .6, top: 16, bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // _performSearch();
                                    // _showSearchDialog();
                                    Get.to(() => ChooseInstructor());
                                  },
                                  child: Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 500,
                                  child:
                                      //  FlutterMap(
                                      //   mapController: mapController,
                                      //   options: MapOptions(
                                      //     center: LatLng(23.875854699999998,
                                      //         90.3795438), // Set initial map center
                                      //     zoom: 13.0, // Set initial zoom level
                                      //   ),
                                      //   layers: [
                                      //     TileLayerOptions(
                                      //       urlTemplate:
                                      //           'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      //       subdomains: ['a', 'b', 'c'],
                                      //     ),
                                      //     MarkerLayerOptions(
                                      //       markers: markers,
                                      //     ),
                                      //   ],
                                      // ),
                                      GoogleMap(
                                          initialCameraPosition:
                                              initialcameraposition)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // Future<void> _showSearchDialog() async {
  //   String address = 'Dhaka';
  //   address = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Search Location'),
  //         content: TextField(
  //           decoration: InputDecoration(hintText: 'Enter an address'),
  //           onSubmitted: (value) {
  //             Navigator.of(context).pop(value);
  //           },
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('Search'),
  //             onPressed: () {
  //               Navigator.of(context).pop(address);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (address != null && address.isNotEmpty) {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       Location location = locations.first;
  //       mapController.move(
  //         LatLng(location.latitude, location.longitude),
  //         13.0,
  //       );
  //       setState(() {
  //         markers.clear();
  //         markers.add(
  //           Marker(
  //             width: 30.0,
  //             height: 30.0,
  //             point: LatLng(location.latitude, location.longitude),
  //             builder: (ctx) => Icon(Icons.location_on, color: Colors.red),
  //           ),
  //         );
  //       });
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Location Not Found'),
  //             content: Text('No results found for the provided address.'),
  //             actions: <Widget>[
  //               FlatButton(
  //                 child: Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

}
