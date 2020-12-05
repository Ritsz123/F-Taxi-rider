import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/helper/helperMethods.dart';
import 'package:uber_clone/styles/styles.dart';
import 'package:uber_clone/widgets/divider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double searchContainerHeight = (Platform.isIOS) ? 300 : 275;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;
  Position currentPosition;

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
    String address =
        await HelperMethods.findCoordinateAddress(position, context);
    print(address);
  }

  final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
//        width: 250,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/user_icon.png',
                      height: 60,
                      width: 60,
                    ),
                    35.widthBox,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Ritesh Khadse"
                            .text
                            .size(20)
                            .fontFamily('Brand-Bold')
                            .make(),
                        "View Profile".text.make(),
                      ],
                    ),
                  ],
                ),
              ),
              MyDivider(),
              10.heightBox,
              ListTile(
                leading: Icon(
                  Icons.card_giftcard_outlined,
                  size: kDrawerItemIconSize,
                ),
                title: Text(
                  "Free Rides",
                  style: kDrawerItemTextStyle,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.credit_card_outlined,
                  size: kDrawerItemIconSize,
                ),
                title: Text(
                  "Payments",
                  style: kDrawerItemTextStyle,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  size: kDrawerItemIconSize,
                ),
                title: Text(
                  "Ride History",
                  style: kDrawerItemTextStyle,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.contact_support_outlined,
                  size: kDrawerItemIconSize,
                ),
                title: Text(
                  "Support",
                  style: kDrawerItemTextStyle,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  size: kDrawerItemIconSize,
                ),
                title: Text(
                  "About",
                  style: kDrawerItemTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.terrain,
              initialCameraPosition: _kLake,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapBottomPadding = (Platform.isIOS) ? 270 : 280;
                });
                setupPositionLocator();
              },
            ),
            //Menu button
            Positioned(
              top: (Platform.isIOS) ? 44 : 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
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
                      Icons.menu,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
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
                    "Where are you going"
                        .text
                        .size(18)
                        .fontFamily('Brand-Bold')
                        .make(),
                    20.heightBox,
                    Container(
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
                            "Your residential Address"
                                .text
                                .size(13)
                                .color(MyColors.colorDimText)
                                .make(),
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
                            "Your office Address"
                                .text
                                .size(13)
                                .color(MyColors.colorDimText)
                                .make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).pSymmetric(h: 24, v: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
