import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/requestHelper.dart';

class HelperMethods {
  static Future<String> findCoordinateAddress(Position position) async {
    String placeAddress = "";
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKeyGeoCode";
    var response = await RequestHelper.getRequest(url);
    if (response != 'Request Failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
