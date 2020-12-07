import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/dataModels/address.dart';
import 'package:uber_clone/dataModels/placeSuggestion.dart';
import 'package:uber_clone/dataProvider/appData.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/requestHelper.dart';
import 'package:uber_clone/widgets/progressIndicator.dart';
import 'package:velocity_x/velocity_x.dart';

class SuggestionTile extends StatelessWidget {
  final PlaceSuggestion suggestion;
  SuggestionTile({@required this.suggestion});

  getPlaceDetails(String placeID, context) async {
//    show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(status: 'Please wait...'),
    );

    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeID&key=$billingMapKey";
    var response = await RequestHelper.getRequest(url);

//    after request success remove loading dialog
    Navigator.pop(context);

    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeID = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];
      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
//      update data in provider class
      print('Destination place: ${thisPlace.placeName}');
//      close this screen
      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(suggestion.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: MyColors.colorDimText,
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.heightBox,
                  suggestion.mainText.text
                      .overflow(TextOverflow.ellipsis)
                      .maxLines(2)
                      .size(16)
                      .make(),
                  2.heightBox,
                  suggestion.secondaryText.text
                      .size(12)
                      .overflow(TextOverflow.ellipsis)
                      .maxLines(2)
                      .color(MyColors.colorDimText)
                      .make(),
                  8.heightBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
