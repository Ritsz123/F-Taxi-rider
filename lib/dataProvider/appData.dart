import 'package:flutter/cupertino.dart';
import 'package:uber_clone/dataModels/address.dart';

class AppData extends ChangeNotifier {
  Address _pickUpAddress;
  Address _destinationAddress;

  void updateDestinationAddress(Address newAddress) {
    _destinationAddress = newAddress;
    notifyListeners();
  }

  void updatePickupAddress(Address newAddress) {
    _pickUpAddress = newAddress;
    notifyListeners();
  }

  Address getPickUpAddress() {
    return _pickUpAddress;
  }

  Address getDestinationAddress() {
    return _destinationAddress;
  }
}
