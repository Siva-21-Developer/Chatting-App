import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Image_uploads extends StatefulWidget {
  const Image_uploads({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<Image_uploads> createState() => _Image_uploadsState();
}

class _Image_uploadsState extends State<Image_uploads> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.greenAccent,
          foregroundImage:
          _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        Positioned(bottom: -10,right: -10, child: IconButton(onPressed: _pickImage, icon: Icon(Icons.camera_alt_outlined),))
      ],
    );
  }
}
