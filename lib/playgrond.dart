import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:s/photo_model.dart';
import 'package:connectivity/connectivity.dart';

class Playground extends StatefulWidget {
  const Playground({Key? key}) : super(key: key);

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  Future<List<ImageModel>> readAllImages() async {
    final hiveBox = await Hive.openBox('images');
    final List<dynamic> imageList = hiveBox.values.toList();
    final List<ImageModel> images = imageList.cast<ImageModel>();

    hiveBox.close();

    return images;
  }

  void createImage(String imagePath) async {
    final hiveBox = await Hive.openBox('images');

    final imageModel = ImageModel()..imagePath = imagePath;
    hiveBox.add(imageModel);

    hiveBox.close();
  }

  void performCRUDOperations() async {
    // Create an image
    final imagePath = 'images/intructor.jpg';
    createImage(imagePath);

    // Read all images
    final images = await readAllImages();

    // Update an image
    if (images.isNotEmpty) {
      final imageModel = images.first;
      final newImagePath = 'images/intructor.jpg';
      updateImage(imageModel, newImagePath);
    }

    // Delete an image
    if (images.isNotEmpty) {
      final imageModel = images.first;
      deleteImage(imageModel);
    }
  }

  void updateImage(ImageModel imageModel, String newImagePath) async {
    final hiveBox = await Hive.openBox('images');

    imageModel.imagePath = newImagePath;
    imageModel.save();

    hiveBox.close();
  }

  void deleteImage(ImageModel imageModel) async {
    final hiveBox = await Hive.openBox('images');

    imageModel.delete();

    hiveBox.close();
  }

  void displaySavedImages() async {
    final hiveBox = await Hive.openBox('images');
    final List images = hiveBox.values.toList();

    for (final imageModel in images) {
      final imageFile = File(imageModel.imagePath);
      // Display the image using the imageFile
      // ...
    }

    hiveBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder<List<ImageModel>>(
            future: readAllImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading images'),
                );
              } else {
                final List<ImageModel> images = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final imageModel = images[index];
                    final imageFile = File(imageModel.imagePath);

                    return Image.file(imageFile);
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
