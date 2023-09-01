import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/icloudstorage_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

class GalleryGridScreen extends StatefulWidget {
  const GalleryGridScreen({super.key});

  @override
  State<GalleryGridScreen> createState() => _GalleryGridScreenState();
}

class _GalleryGridScreenState extends State<GalleryGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gallery view"),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Icon(Icons.camera_alt),
            onPressed: () async {
              // await selectPhoto();
              // showModalBottomSheet(
                
              //     context: context, builder: (context) => buildSheet());
            },
          ),
        ));
  }

  // Widget buildSheet() => MediaGrid();

  Future selectPhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) return;

    final path = result.files.single.path!;

    uploadPhoto(File(path));
  }

  Future uploadPhoto(File? file) async {
    if (file == null) return;

    final filename = basename(file.path);
    final destination = "/files/$filename";

    final downloadUrl = await provider
        .get<ICloudStorageService>()
        .uploadFile(destination, file);

    print('Download link: $downloadUrl');
  }
}
