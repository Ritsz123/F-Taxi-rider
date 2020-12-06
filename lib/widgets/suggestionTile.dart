import 'package:flutter/material.dart';
import 'package:uber_clone/Colors.dart';
import 'package:uber_clone/dataModels/placeSuggestion.dart';
import 'package:velocity_x/velocity_x.dart';

class SuggestionTile extends StatelessWidget {
  final PlaceSuggestion suggestion;
  SuggestionTile({@required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
