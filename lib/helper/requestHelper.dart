import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // success
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'Request Failed';
      }
    } catch (e) {
      return 'Request Failed';
    }
  }
}
