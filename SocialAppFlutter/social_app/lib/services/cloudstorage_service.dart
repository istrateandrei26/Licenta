import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:social_app/services/icloudstorage_service.dart';

class CloudStorageService implements ICloudStorageService {
  @override
  Future<String?> uploadFile(String destination, File? file) async {
    try {
      if (file == null) return null;

      final ref = FirebaseStorage.instance.ref(destination);

      UploadTask task = ref.putFile(file);
      final snapshot = await task.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException {
      return null;
    }
  }
}
