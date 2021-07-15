import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/userModel.dart';
import 'package:uber_clone/globals.dart';

class AppData extends ChangeNotifier {
  Address? _pickUpAddress;
  Address? _destinationAddress;
  UserModel? _currentUser;

  late SharedPreferences _preferences;

  _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

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

  Future<bool> cacheAuthToken(String token) async {
    await _initSharedPreferences();

    logger.i('Caching auth token');

    bool success = false;
    try {
       success = await _preferences.setString('authToken', token);
    } catch(e) {
      logger.e(e);
      throw Exception('unable to cache token');
    }
    return success;
  }

  Future<String> getAccessToken() async {
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

    return token;
  }

  UserModel? getCurrentUser() {
    return _currentUser;
  }

  void setCurrentUser(UserModel userModel){
    _currentUser = userModel;
    notifyListeners();
  }
}
