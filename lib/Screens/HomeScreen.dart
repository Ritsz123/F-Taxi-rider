import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/Screens/searchScreen.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/directionDetails.dart';
import 'package:uber_clone/dataModels/userModel.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
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


class HomeScreen extends StatefulWidget {
  static const String id = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double searchContainerHeight = (Platform.isIOS) ? 300 : 275;
  double rideDetailsContainerHeight = 0; //  (Platform.isIOS) ? 235 : 250;
  double requestingRideContainerHeight = 0; //(Platform.isIOS) ? 220 : 190;
  Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController mapController;
  double mapBottomPadding = 0;
  Position? currentPosition;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool drawerCanOpen = true;
  late DatabaseReference rideRef;
  DirectionDetails? tripDirectionDetails;
  late String _authToken;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    _authToken = await HelperMethods.getAccessToken();

    var response = await RequestHelper.getRequest(url: serviceUrl.getUserData, withAuthToken: true, token: _authToken);
    UserModel model = UserModel.fromJson(response['body']);
    Provider.of<AppData>(context, listen: false).setCurrentUser(model);
    logger.i('get user info success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
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
                  mapBottomPadding = (Platform.isIOS) ? 270 : 280;
                });
                setupPositionLocator();
              },
            ),
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

  Widget _drawerIcon() {
    return Positioned(
      top: (Platform.isIOS) ? 44 : 20,
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
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeIn,
        child: Container(
          height: searchContainerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.heightBox,
              "Nice to see you".text.size(10).make(),
              "Where are you going".text.size(18).fontFamily('Brand-Bold').make(),
              20.heightBox,
              GestureDetector(
                onTap: () async {
                  var screenResponse = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                  if (screenResponse == 'getDirection') {
                    showRideDetailsPanel();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      10.widthBox,
                      "Search Destination".text.make(),
                    ],
                  ).p12(),
                ),
              ),
              22.heightBox,
              Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: MyColors.colorDimText,
                  ),
                  12.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Add Home".text.make(),
                      3.heightBox,
                      "Your residential Address".text.size(13).color(MyColors.colorDimText).make(),
                    ],
                  ),
                ],
              ),
              10.heightBox,
              MyDivider(),
              16.heightBox,
              Row(
                children: [
                  Icon(
                    Icons.work_outlined,
                    color: MyColors.colorDimText,
                  ),
                  12.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Add Work".text.make(),
                      3.heightBox,
                      "Your office Address".text.size(13).color(MyColors.colorDimText).make(),
                    ],
                  ),
                ],
              ),
            ],
          ).pSymmetric(h: 24, v: 18),
        ),
      ),
    );
  }

  Widget _rideDetails() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 150),
        child: Container(
          height: rideDetailsContainerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                color: MyColors.colorAccent1,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/taxi.png',
                      height: 70,
                      width: 70,
                    ),
                    16.widthBox,
                    Column(
                      children: [
                        "Taxi"
                            .text
                            .size(18)
                            .fontFamily('Brand-Bold')
                            .make(),
                        "${tripDirectionDetails != null ? tripDirectionDetails!.distanceText : ''}"
                            .text
                            .size(16)
                            .color(MyColors.colorTextLight)
                            .make(),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    "₹ ${tripDirectionDetails != null ? HelperMethods.estimateFares(tripDirectionDetails!) : ''}".text.size(18).fontFamily('Brand-Bold').make(),
                  ],
                ).pSymmetric(h: 16),
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.moneyBillAlt,
                    size: 18,
                    color: MyColors.colorTextLight,
                  ),
                  16.widthBox,
                  DropdownButton(
                    onChanged: (dynamic value) {},
                    items: [
                      DropdownMenuItem(child: "Cash".text.make()),
                    ],
                  ),
                  5.widthBox,
                ],
              ).pSymmetric(h: 16),
              TaxiButton(
                onPressed: () {
                  showRequestingRidePanel();
                },
                buttonText: 'Request cab',
              ).pSymmetric(h: 16),
            ],
          ).pSymmetric(v: 18),
        ),
      ),
    );
  }
  void showRideDetailsPanel() async {
    await getDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = (Platform.isIOS) ? 225 : 235;
      mapBottomPadding = (Platform.isIOS) ? 270 : 280;
      drawerCanOpen = false;
    });
  }

  Widget _requestingRidePanel() {
    return  Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeIn,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 18,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          height: requestingRideContainerHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.heightBox,
              SizedBox(
                width: double.infinity,
                child: TextLiquidFill(
                  text: 'Requesting a ride...',
                  waveColor: MyColors.colorTextSemiLight,
                  boxBackgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 40,
                ),
              ),
              20.heightBox,
              GestureDetector(
                onTap: () {
                  cancelRideRequestInDatabase();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1,
                      color: MyColors.colorLightGrayFair,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ),
                ),
              ),
              10.heightBox,
              "Cancel Ride".text.make(),
            ],
          ).pSymmetric(h: 24, v: 18),
        ),
      ),
    );
  }
  void showRequestingRidePanel() {
    rideDetailsContainerHeight = 0;
    requestingRideContainerHeight = (Platform.isIOS) ? 220 : 190;
    mapBottomPadding = (Platform.isIOS) ? 270 : 280;
    drawerCanOpen = false;
    setState(() {});
    createRideRequestToDatabase();
  }

  void setupPositionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
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

    DirectionDetails thisDetails =
        await (HelperMethods.getDirectionDetails(pickUpLatLng, destLatLng));
    setState(() {
      tripDirectionDetails = thisDetails;
    });

//    dismiss loading
    Navigator.pop(context);

//    print('Encoded points: ${thisDetails.encodedPoints}');

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng>? results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

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
  }

  void cancelRideRequestInDatabase() {
    rideRef.remove();
    resetApp();
  }
}
