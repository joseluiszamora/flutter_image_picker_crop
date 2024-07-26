import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageProfilePage extends StatefulWidget {
  const ImageProfilePage({super.key});

  @override
  State<ImageProfilePage> createState() => _ImageProfilePageState();
}

class _ImageProfilePageState extends State<ImageProfilePage> {
  File? _image;

  Future selectImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return null;

    File? imgCropped = File(image.path);
    imgCropped = await cropImage(imgCropped);

    setState(() {
      _image = imgCropped;
    });
  }

  Future cropImage(File imageFile) async {
    CroppedFile? cropImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (cropImage == null) return null;
    return File(cropImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //* TITLE SECTION
              const Center(
                child: Text(
                  'My Image Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              //* IMAGE SECTION
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: _image == null
                        ? const Text('Select Image')
                        : CircleAvatar(
                            minRadius: 50,
                            backgroundImage: FileImage(_image!),
                          ),
                  ),
                ),
              ),
              //* BUTTONS SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customButton("Image from Camera", () {
                    selectImage(ImageSource.camera);
                  }),
                  const SizedBox(height: 20),
                  customButton("Image from Gallery", () {
                    selectImage(ImageSource.gallery);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton customButton(String text, void Function() onPress) =>
      ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(elevation: 3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      );
}
