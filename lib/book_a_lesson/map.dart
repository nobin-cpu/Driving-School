import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GoogleMaps;
import 'package:flutter_map/flutter_map.dart' as FlutterMap;
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  String _searchQuery = "";
  GoogleMapController? _mapController;
  TextEditingController _searchController = TextEditingController();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _searchLocation() {
    // Perform the search and update the map with the searched location.
    // In a real app, you would use a location API to fetch search results.
    // For simplicity, we'll just update the marker's position in this example.
    setState(() {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(37.7749,
                -122.4194), // Replace with the actual searched location's coordinates
            zoom: 15,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          child: Column(
            children: [
              // TextField(
              //     controller: _searchController,
              //     onChanged: (value) {
              //       setState(() {
              //         _searchQuery = value;
              //       });
              //     },
              //     decoration: InputDecoration(
              //       hintText: 'Search location',
              //       suffixIcon: IconButton(
              //         icon: Icon(Icons.search),
              //         onPressed: () {
              //           _searchLocation();
              //         },
              //       ),
              //     )),
              // // Expanded(
              // //   child: GoogleMap(
              // //     initialCameraPosition: CameraPosition(
              // //       target: LatLng(
              // //           37.7749, -122.4194), // Default location (San Francisco)
              // //       zoom: 12,
              // //     ),
              // //     onMapCreated: (controller) {
              // //       setState(() {
              // //         _mapController = controller;
              // //       });
              // //     },
              // //     markers: Set<GoogleMaps.Marker>.from(_createMarkers()),
              // //   ),
              // // ),

              GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
