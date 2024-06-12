import 'package:flutter/material.dart';
import 'dart:io';

// ignore: unused_import
import 'DisplayPictureScreen.dart';
export 'DisplayPictureScreen.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Display the Picture'),
          backgroundColor: Color(0xFF01B8E0),
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
          child: imagePath == ""
              ? Container()
              : Container(child: Image.file(File(imagePath))),
        ));
  }
}
