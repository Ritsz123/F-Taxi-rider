import 'package:flutter/cupertino.dart';
import 'package:uber_clone/dataModels/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpAddress;
  void updatePickupAddress(Address newAddress) {
    pickUpAddress = newAddress;
    notifyListeners();
  }
}
