import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/Screens/searchScreen.dart';
import 'package:uber_clone/dataModels/NearByDriver.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/directionDetails.dart';
import 'package:uber_clone/dataModels/userModel.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/geoHelper.dart';
import 'package:uber_clone/helper/helperMethods.dart';
import 'package:uber_clone/helper/requestHelper.dart';
import 'package:uber_clone/widgets/MyDrawer.dart';
import 'package:uber_clone/widgets/divider.dart';
import 'package:uber_clone/widgets/progressIndicator.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_clone/serviceUrls.dart' as serviceUrl;
part '../widgets/search_panel.dart';
part '../widgets/ride_details.dart';
part '../widgets/requesting_ride_panel.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double searchContainerHeight = 275;
  double rideDetailsContainerHeight = 0; //   250;
  double requestingRideContainerHeight = 0; // 190;
  Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;
  late Position currentPosition;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool drawerCanOpen = true;
  late DatabaseReference rideRef;
  DirectionDetails? tripDirectionDetails;
  late String _authToken;
  final String availableDriversPathInDB = "driversAvailable";
  BitmapDescriptor? _nearByCarIcon;
  bool _tripAccepted = false;

  void createNearByIcon() {
    if(_nearByCarIcon != null) return;
    ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
    BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      'assets/images/car_android.png',
    ).then((icon) => _nearByCarIcon = icon);
  }

  @override
  void initState() {
    super.initState();
    _authToken = Provider.of<AppData>(context, listen: false).getAuthToken();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    var response = await RequestHelper.getRequest(url: serviceUrl.getUserData, withAuthToken: true, token: _authToken);
    UserModel model = UserModel.fromJson(response['body']);
    Provider.of<AppData>(context, listen: false).setCurrentUser(model);
    logger.i('get user info success');
  }

  @override
  Widget build(BuildContext context) {
    createNearByIcon();
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            _getMap(),
            /// Drawer Icon
            _drawerIcon(),

            /// search panel
            _searchPanel(),

            /// ride details
            _rideDetails(),

           /// request ride panel
            _requestingRidePanel(),
          ],
        ),
      ),
    );
  }

  Widget _getMap() {
    return GoogleMap(
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      polylines: _polylines,
      markers: _markers,
      circles: _circles,
      padding: EdgeInsets.only(bottom: mapBottomPadding),
      mapType: MapType.normal,
      initialCameraPosition: india,
      onMapCreated: (GoogleMapController controller) {
        _completer.complete(controller);
        mapController = controller;
        setState(() {
          mapBottomPadding = 280;
        });
        setupPositionLocator();
      },
    );
  }

  Widget _drawerIcon() {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () {
          drawerCanOpen
            ? _scaffoldKey.currentState!.openDrawer()
            : resetApp();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 0.5,
                offset: Offset(0.7, .07),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(
              drawerCanOpen ? Icons.menu : Icons.close,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchPanel() {
    return SearchPanel(
      searchContainerHeight: searchContainerHeight,
      onTapSearch: showRideDetailsPanel,
    );
  }

  Widget _rideDetails() {
    return RideDetails(
      rideDetailsContainerHeight: rideDetailsContainerHeight,
      tripDirectionDetails: tripDirectionDetails,
      onTapRequestRide: showRequestingRidePanel,
    );
  }

  void showRideDetailsPanel() async {
    await getDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 235;
      mapBottomPadding = 280;
      drawerCanOpen = false;
    });
  }

  Widget _requestingRidePanel() {
    return RequestingRidePanel(
      requestingRideContainerHeight: requestingRideContainerHeight,
      onCancelRide: cancelRideRequestInDatabase,
      tripAccepted: _tripAccepted,
    );
  }

  void showRequestingRidePanel() {
    rideDetailsContainerHeight = 0;
    requestingRideContainerHeight = (Platform.isIOS) ? 220 : 190;
    mapBottomPadding = (Platform.isIOS) ? 270 : 280;
    drawerCanOpen = false;
    setState(() {});
    createRideRequestToDatabase();
    notifyNearestDriver(GeoHelper.nearByDrivers.first);
  }

  void notifyNearestDriver(NearByDriver nearestDriver) async {
    logger.i('nearest found driver ${nearestDriver.id}');

    final String url = serviceUrl.getDriverFcmToken + '?driverid=${nearestDriver.id}';

    try{
      Map<String, dynamic> response = await RequestHelper.getRequest(
        url: url,
        token: _authToken,
        withAuthToken: true,
      );

      final String fcmToken = response['body']['fcmToken'];

      logger.i('new ride id : ${rideRef.key}');
      logger.i('retrieved token: $fcmToken');

      //send notification to the token
      HelperMethods.sendFcmNotification(fcmToken, rideRef.key);

    } catch(exception) {
      logger.e(exception);
    }
  }

  void setupPositionLocator() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(
      target: pos,
      zoom: 16,
    );
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(cp),
    );
    String address = await HelperMethods.findCoordinateAddress(position, context);
    logger.i('source address: $address');
    startGeoFireListener();
  }

  Future<void> getDirection() async {
    Address pickUp = Provider.of<AppData>(context, listen: false).getPickUpAddress();
    Address dest = Provider.of<AppData>(context, listen: false).getDestinationAddress();
    LatLng pickUpLatLng = LatLng(pickUp.latitude, pickUp.longitude);
    LatLng destLatLng = LatLng(dest.latitude, dest.longitude);

//    show loading
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(status: "Please wait..."),
      barrierDismissible: false,
    );

    DirectionDetails thisDetails = await (HelperMethods.getDirectionDetails(
        context: context,
        startPosition: pickUpLatLng,
        endPosition: destLatLng,
      )
    );

    setState(() {
      tripDirectionDetails = thisDetails;
    });

//    dismiss loading
    Navigator.pop(context);

//    print('Encoded points: ${thisDetails.encodedPoints}');

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng>? results = polylinePoints.decodePolyline(thisDetails.encodedPoints);

//    clear previous points before adding new
    polylineCoordinates.clear();

    if (results.isNotEmpty) {
//      loop to all points and convert them to latlng
      results.forEach((PointLatLng p) {
        polylineCoordinates.add(LatLng(p.latitude, p.longitude));
      });
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyId'),
        color: Colors.deepPurple,
        width: 5,
        points: polylineCoordinates,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        geodesic: true,
      );

//      clear previous line before adding new

      _polylines.clear();
      setState(() {
        _polylines.add(polyline);
      });

//     zoom out to see the complete polyline from source to destination

      LatLngBounds bounds;
      if (pickUpLatLng.latitude > destLatLng.latitude &&
          pickUpLatLng.longitude > destLatLng.longitude) {
//     bottom left of map as destination point & top right as pickup point
        bounds = LatLngBounds(southwest: destLatLng, northeast: pickUpLatLng);
      } else if (pickUpLatLng.longitude > destLatLng.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, destLatLng.longitude),
          northeast: LatLng(destLatLng.latitude, pickUpLatLng.longitude),
        );
      } else if (pickUpLatLng.latitude > destLatLng.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, destLatLng.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: pickUpLatLng, northeast: destLatLng);
      }
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

      Marker pickUpMarker = Marker(
        markerId: MarkerId('pickupMarker'),
        position: pickUpLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: pickUp.placeName, snippet: "My Location"),
      );

      Marker destMarker = Marker(
        markerId: MarkerId('destMarker'),
        position: destLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: dest.placeName, snippet: "Destination"),
      );

      setState(() {
        _markers.add(pickUpMarker);
        _markers.add(destMarker);
      });

      Circle pickUpCircle = Circle(
        circleId: CircleId('pickupCircle'),
        fillColor: Colors.green,
        strokeColor: Colors.green,
        strokeWidth: 3,
        radius: 12,
        center: pickUpLatLng,
      );

      Circle destCircle = Circle(
        circleId: CircleId('destCircle'),
        fillColor: Colors.redAccent,
        strokeColor: Colors.redAccent,
        strokeWidth: 3,
        radius: 12,
        center: destLatLng,
      );

      setState(() {
        _circles.add(pickUpCircle);
        _circles.add(destCircle);
      });
    }
  }

  void startGeoFireListener() {
    Geofire.initialize(availableDriversPathInDB);
    
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 10)!.listen((map) {
      // logger.i(map);

      if (map != null) {
        var callBack = map['callBack'];
        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByDriver nearByDriver = NearByDriver(
              id: map['key'],
              lat: map['latitude'],
              lng: map['longitude'],
            );
            GeoHelper.nearByDrivers.add(nearByDriver);
            break;

          case Geofire.onKeyExited:
            GeoHelper.removeNearByDriverFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            GeoHelper.removeNearByDriverFromList(map['key']);
            NearByDriver nearByDriver = NearByDriver(
              id: map['key'],
              lat: map['latitude'],
              lng: map['longitude'],
            );
            GeoHelper.nearByDrivers.add(nearByDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            // All Initial Data is loaded
            updateDriversOnMap();
            logger.i('total drivers available : ${GeoHelper.nearByDrivers.length}');
            break;
        }
      }
    });
  }

  void updateDriversOnMap() {
    _markers.clear();

    //loop all the nearby drivers and create marker set.
    _markers = GeoHelper.nearByDrivers.map(
      (NearByDriver driver) {
        LatLng _driverPos = LatLng(driver.lat, driver.lng);
        return Marker(
          markerId: MarkerId('marker${driver.id}'),
          position: _driverPos,
          icon: _nearByCarIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          rotation: Random().nextInt(360).toDouble(),
        );
      }
    ).toSet();

    setState(() {});
  }

  void resetApp() {
    polylineCoordinates.clear();
    _polylines.clear();
    _markers.clear();
    _circles.clear();
    rideDetailsContainerHeight = 0;
    searchContainerHeight = (Platform.isIOS) ? 300 : 275;
    mapBottomPadding = (Platform.isIOS) ? 270 : 280;
    drawerCanOpen = true;
    requestingRideContainerHeight = 0;
    setState(() {});
    setupPositionLocator();
  }

  void createRideRequestToDatabase() {
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();
    Address src = Provider.of<AppData>(context, listen: false).getPickUpAddress();
    Address dest = Provider.of<AppData>(context, listen: false).getDestinationAddress();
    UserModel currentUserInfo = Provider.of<AppData>(context, listen: false).getCurrentUser();

    Map srcMap = src.toJson();
    Map destMap = dest.toJson();

    Map rideMap = {
      'createdAt': DateTime.now().toString(),
      'riderId': currentUserInfo.id,
      'pickupAddress': srcMap,
      'destinationAddress': destMap,
      'paymentMethod': 'Cash',
      'driverId': 'waiting',
    };

    rideRef.set(rideMap);

    FirebaseDatabase.instance.reference().child('rideRequest').onChildRemoved.listen(
      (event) {
        if(event.snapshot.key == rideRef.key){
          setState(() {
            _tripAccepted = true;
          });
          logger.i('removed ride request from firebase');
        }
      }
    );

  }

  void cancelRideRequestInDatabase() {
    rideRef.remove();
    resetApp();
  }
}
