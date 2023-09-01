import 'dart:io';


abstract class ICloudStorageService {
  Future<String?> uploadFile(String destination, File file);
}
