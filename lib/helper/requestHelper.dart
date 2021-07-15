import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uber_clone/globals.dart';

class RequestHelper {
  static final List _successResponseCodes = [200, 201, 202, 204, 206];

  static Future<Map<String, dynamic>> getRequest({required String url, bool withAuthToken = false, String? token}) async {
    try {
      if(withAuthToken && token == null){
        throw Exception('Token not provided for withAuthToken request');
      }

      http.Response response = await http.get(
        Uri.parse(url),
        headers: withAuthToken ? {
          'bearer': token!
        } : {}
      );

      if (_successResponseCodes.contains(response.statusCode)) {
        // success
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData as Map<String, dynamic>;
      } else {
        throw Exception('request failed');
      }
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> postRequest({required String url, required Map<String, dynamic> body, bool withAuthToken = false, String? token}) async {
    try {
      if(withAuthToken && token == null){
        throw Exception('Token not provided for withAuthToken request');
      }

      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      // print(response.statusCode);
      if(_successResponseCodes.contains(response.statusCode)) {
        String data = response.body;
        Map<String, dynamic> decodedData = jsonDecode(data);
        return decodedData;
      }else{
        throw Exception(response.statusCode);
      }
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }
}
