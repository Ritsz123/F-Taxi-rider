
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
  static Future<String?> findCoordinateAddress(
      Position position, context) async {
    String? placeAddress = "";
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$billingMapKey";
    var response = await RequestHelper.getRequest(url: url);
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
    var response = await RequestHelper.getRequest(url: url);

    if (response['status'] == 'OK') {
      String distanceText =
      response['routes'][0]['legs'][0]['distance']['text'];
      int distanceValue =
      response['routes'][0]['legs'][0]['distance']['value'];
      String durationText =
      response['routes'][0]['legs'][0]['duration']['text'];
      int durationValue =
      response['routes'][0]['legs'][0]['duration']['value'];
      String encodedPoints =
      response['routes'][0]['overview_polyline']['points'];

      DirectionDetails directionDetails = DirectionDetails(
          distanceText: distanceText,
          distanceValue: distanceValue,
          durationText: durationText,
          durationValue: durationValue,
          encodedPoints: encodedPoints,
      );

      return directionDetails;
    }else {
      throw Exception('Network Exception');
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
}
