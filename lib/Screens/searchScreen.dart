import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var pickupTextController = TextEditingController();
  var destinationTextController = TextEditingController();
  var focusDestination = FocusNode();
  bool focused = false;

  void setDestinationFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
    }
  }

  @override
  Widget build(BuildContext context) {
    String address =
        Provider.of<AppData>(context).pickUpAddress.placeName ?? '';
    pickupTextController.text = address;
    setDestinationFocus();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: "Set Destination"
            .text
            .black
            .size(22)
            .fontFamily('Brand-Bold')
            .make(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
//              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.7, 0.7),
                    spreadRadius: .5,
                    blurRadius: .5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      18.widthBox,
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: pickupTextController,
                            decoration: InputDecoration(
                              hintText: "Pick up Location",
                              fillColor: MyColors.colorLightGrayFair,
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: 8,
                                bottom: 8,
                              ),
                            ),
                          ).p2(),
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      18.widthBox,
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            focusNode: focusDestination,
                            controller: destinationTextController,
                            decoration: InputDecoration(
                              hintText: "Where to?",
                              fillColor: MyColors.colorLightGrayFair,
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                top: 8,
                                bottom: 8,
                              ),
                            ),
                          ).p2(),
                        ),
                      ),
                    ],
                  ),
                ],
              ).pOnly(top: 16, left: 16, right: 16, bottom: 25),
            ),
          ],
        ),
      ),
    );
  }
}
