import 'package:uber_clone/dataModels/NearByDriver.dart';

class GeoHelper {
  static List<NearByDriver> nearByDrivers = [];

  static removeNearByDriverFromList(String id){
    final int index = GeoHelper.nearByDrivers.indexWhere((element) => element.id == id);
    GeoHelper.nearByDrivers.remove(index);
  }
}