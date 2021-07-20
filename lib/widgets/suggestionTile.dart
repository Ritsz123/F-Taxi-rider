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
import 'package:uber_clone/serviceUrls.dart' as serviceUrl;

class SuggestionTile extends StatelessWidget {
  final PlaceSuggestion suggestion;
  final String authToken;

  SuggestionTile({required this.suggestion, required this.authToken});

  getPlaceDetails(String placeID, context) async {
//    show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(status: 'Please wait...'),
    );

    String url = serviceUrl.getPlaceDetails + '?placeId=$placeID';
    try {
      Map<String, dynamic> response = await RequestHelper.getRequest(url: url, token: authToken, withAuthToken: true);
      // after request success remove loading dialog
      Navigator.pop(context);

      Address thisPlace = Address.fromJson(response['body']);

      Provider.of<AppData>(context, listen: false).updateDestinationAddress(thisPlace);

//    update data in provider class
      print('Destination place: ${thisPlace.placeName}');

//    close search screen
      Navigator.pop(context, 'getDirection');

    } catch(e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceDetails(suggestion.placeId, context);
      },
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
                  suggestion.mainText.text.overflow(TextOverflow.ellipsis).maxLines(2).size(16).make(),
                  2.heightBox,
                  suggestion.secondaryText.text.size(12).overflow(TextOverflow.ellipsis).maxLines(2).color(MyColors.colorDimText).make(),
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
