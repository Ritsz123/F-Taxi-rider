import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProgressDialog extends StatelessWidget {
  final String status;

  const ProgressDialog({Key key, @required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(16),
        width: double.infinity,
        child: Row(
          children: [
            5.widthBox,
            CircularProgressIndicator(),
            25.widthBox,
            status.text.xl.bold.make().shimmer(),
          ],
        ).p16(),
      ),
    );
  }
}
