import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/userModel.dart';
import 'package:uber_clone/globals.dart';

class AppData extends ChangeNotifier {
  Address? _pickUpAddress;
  Address? _destinationAddress;
  UserModel? _currentUser;

  void updateDestinationAddress(Address newAddress) {
    _destinationAddress = newAddress;
    notifyListeners();
  }

  void updatePickupAddress(Address newAddress) {
    _pickUpAddress = newAddress;
    notifyListeners();
  }

  Address? getPickUpAddress() {
    return _pickUpAddress;
  }

  Address? getDestinationAddress() {
    return _destinationAddress;
  }

  UserModel? getCurrentUser() {
    return _currentUser;
  }

  void setCurrentUser(UserModel userModel){
    _currentUser = userModel;
    notifyListeners();
  }
}
