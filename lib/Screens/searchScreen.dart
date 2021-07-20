import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/dataModels/placeSuggestion.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/requestHelper.dart';
import 'package:uber_clone/widgets/divider.dart';
import 'package:uber_clone/widgets/suggestionTile.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uber_clone/serviceUrls.dart' as serviceUrl;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var pickupTextController = TextEditingController();
  var destinationTextController = TextEditingController();
  var focusDestination = FocusNode();
  bool focused = false;
  List<PlaceSuggestion> destinationSuggestionList = [];
  late String authToken;

  @override
  void initState() {
    super.initState();
    authToken = Provider.of<AppData>(context, listen: false).getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    String address = Provider.of<AppData>(context).getPickUpAddress().placeName;
    pickupTextController.text = address;
    setDestinationFocus();
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
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
                              onChanged: (value) {
                                getSearchSuggestions(value);
                              },
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
              destinationSuggestionList.length > 0
                ? _suggestionTileList()
                : Container()
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
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
      title: "Set Destination".text.black.size(22).fontFamily('Brand-Bold').make(),
    );
  }

  Widget _suggestionTileList() {
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return SuggestionTile(
          suggestion: destinationSuggestionList[index],
          authToken: authToken,
        );
      },
      separatorBuilder: (BuildContext context, int index) => MyDivider(),
      itemCount: destinationSuggestionList.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }

  void setDestinationFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
    }
  }

  void getSearchSuggestions(String placeName) async {

    if (placeName.length > 1) {
      String url = serviceUrl.getPlaceSearchSuggestion + '?place=$placeName';

      logger.i('making call for place suggestion');
      try{
        Map<String, dynamic> response = await RequestHelper.getRequest(
          url: url,
          withAuthToken: true,
          token: authToken,
        );

        var predictionJSON = response['body']['predictions'];
        List<PlaceSuggestion> thisList = (predictionJSON as List)
            .map((e) => PlaceSuggestion.fromJson(e))
            .toList();

        setState(() {
          destinationSuggestionList = thisList;
        });
      } catch(e) {
        logger.e(e);
      }
    }
  }
}
