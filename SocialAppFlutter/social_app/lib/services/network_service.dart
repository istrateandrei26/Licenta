import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<bool> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();

    return result == ConnectivityResult.none ? false : true;
  }
}
