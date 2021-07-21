//ritesh'account
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:uber_clone/dataModels/userModel.dart';

String mapKey = "AIzaSyBGFnI2gX1UKFf3XWBo6uUGCE0HhxKzMlo";

//lasina's account
String billingMapKey = "AIzaSyAx8ltyAvXjCgL9nPZaJRSlR5ZRwJ-j0So";

//usually both these keys are same but as I am using another account for billing my keys are different

final CameraPosition india = CameraPosition(
  bearing: 0,
  target: LatLng(28.6139, 77.2090),
  tilt: 0,
  zoom: 3,
);

Logger logger = Logger();

User? currentUser;
