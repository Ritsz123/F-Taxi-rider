import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/directionDetails.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/requestHelper.dart';

class HelperMethods {
  static Future<String> findCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$billingMapKey";
    var response = await RequestHelper.getRequest(url);
    if (response != 'Request Failed') {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickUpAddress = new Address();
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$billingMapKey";
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    if (response['status'] == 'OK') {
      DirectionDetails directionDetails = DirectionDetails();
      directionDetails.distanceText =
          response['routes'][0]['legs']['distance']['text'];
      directionDetails.distanceValue =
          response['routes'][0]['legs']['distance']['value'];
      directionDetails.durationText =
          response['routes'][0]['legs']['duration']['text'];
      directionDetails.durationValue =
          response['routes'][0]['legs']['duration']['value'];
      directionDetails.encodedPoints =
          response['routes'][0]['overview_polyline']['points'];
      return directionDetails;
    }
  }
}
