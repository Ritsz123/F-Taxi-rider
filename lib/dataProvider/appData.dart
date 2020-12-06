import 'package:flutter/cupertino.dart';
import 'package:uber_clone/dataModels/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpAddress;
  Address destinationAddress;

  void updateDestinationAddress(Address newAddress) {
    destinationAddress = newAddress;
    notifyListeners();
  }

  void updatePickupAddress(Address newAddress) {
    pickUpAddress = newAddress;
    notifyListeners();
  }
}
