import 'dart:async';
import 'dart:io';
import 'package:uber_clone/Colors.dart';
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
  double searchContainerHeight = (Platform.isIOS) ? 300 : 275;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: _kLake,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapBottomPadding = (Platform.isIOS) ? 270 : 280;
                });
              },
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
