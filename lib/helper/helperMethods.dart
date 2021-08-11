import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/directionDetails.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/requestHelper.dart';
import 'package:uber_clone/serviceUrls.dart' as serviceUrl;
import 'package:http/http.dart' as http;


class HelperMethods {

  static late SharedPreferences _preferences;

  static Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<String> findCoordinateAddress(Position position, context) async {
    String placeAddress = '';
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
      connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    final String url = serviceUrl.getLatLngDetails + '/?lat=${position.latitude}&lng=${position.longitude}';
    final String token = Provider.of<AppData>(context,listen: false).getAuthToken();

    try {
      logger.i('making request to get latlng details');
      Map<String, dynamic> response = await RequestHelper.getRequest(
        url: url,
        withAuthToken: true,
        token: token,
      );

      Address pickUpAddress = new Address(
        latitude: position.latitude,
        longitude: position.longitude,
        placeName: placeAddress = response['body']['results'][0]['formatted_address'],
      );

      logger.i('get latlng details success');
      Provider.of<AppData>(context, listen: false).updatePickupAddress(pickUpAddress);
    } catch (e) {
      logger.e(e);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails({required BuildContext context, required LatLng startPosition, required LatLng endPosition}) async {

    final String srcUrlPart = '?sourceLatLng=${startPosition.latitude},${startPosition.longitude}';
    final String destUrlPart = '&destLatLng=${endPosition.latitude},${endPosition.longitude}';

    final String url = serviceUrl.getRouteDetails + srcUrlPart + destUrlPart;
    final String token = Provider.of<AppData>(context,listen: false).getAuthToken();

    try {
      Map<String, dynamic> response = await RequestHelper.getRequest(
        url: url,
        withAuthToken: true,
        token: token,
      );

      DirectionDetails directionDetails = DirectionDetails.fromJson(response['body']);

      return directionDetails;
    } catch(e) {
      logger.e(e);
      throw e;
    }
  }

  static int estimateFares(DirectionDetails details) {
    // uber current rates
    // base ₹47.00
    //Per-minute ₹1.58
    //Per Km ₹7.66
    double baseFare = 47.0;
    double _perKmFare = 7.0;
    double _perMinuteFare = 1.0;
    double distanceFare = (details.distanceValue/ 1000) *
        _perKmFare; //convert mts to kms & then calculate fare
    double timeFare = (details.durationValue/ 60) * _perMinuteFare;

    double totalFare = baseFare + distanceFare + timeFare;
    return totalFare.truncate();
  }

  static Future<bool> cacheAuthToken(String token) async {
    await _initSharedPreferences();

    logger.i('Caching auth token');

    bool success = false;
    try {
      success = await _preferences.setString('authToken', token);
    } catch(e) {
      logger.e(e);
      throw Exception('unable to cache token');
    }
    logger.i('Auth token cache success');
    return success;
  }

  static Future<String> getAccessToken() async {
    await _initSharedPreferences();

    logger.i('getting cached auth token');

    String? token;
    try {
      token = _preferences.getString('authToken');
    } catch(e) {
      logger.e(e);
      throw Exception('unable to retrieve token');
    }
    if(token == null) {
      logger.e('Token not found');
      throw Exception('Token not found');
    }
    logger.i('access token retrieve success');
    return token;
  }

  static Future<void> sendFcmNotification(String fcmToken, String rideId) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAe-uvtvA:APA91bFEEC0VTbzbMT1d0hoBibNgmfIun9Ye9maDYuzs7ECiv1nBGmdtLg0JzH52Jp6KkCbSI606QWuUVRgxxKmIOP3I2npSaR4A-XN0XiZs4quO52CyMXgXUBgiHUHlsL-vpL5xS1yP'
    };

    final Map<String, dynamic> reqBody = {
      'notification': {
        'title': 'new Trip request'
      },
      'data': {
        'rideId': rideId
      },
      'priority': 'high',
      'to': fcmToken
    };

    try{
      http.Response response  = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers,
        body: jsonEncode(reqBody),
      );

      logger.i('fcm notification sent ${response.body}');

    } catch(exception){
      logger.e(exception);
    }
  }
}
