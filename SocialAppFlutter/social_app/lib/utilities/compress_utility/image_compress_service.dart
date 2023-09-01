import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressService {
  static Future<Uint8List?> compressImageFromPath(
      String path, int minWidth, int minHeight, int quality) async {
    var result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 150,
      minHeight: 150,
      quality: 60,
    );

    return result;
  }

  static Future<Uint8List?> compressImageFromBytes(
      Uint8List bytes, int minWidth, int minHeight, int quality) async {
    var result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 150,
      minHeight: 150,
      quality: 60,
    );

    return result;
  }
}
