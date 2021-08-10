part of  '../Screens/HomeScreen.dart';

class RideDetails extends StatelessWidget {
  final double rideDetailsContainerHeight;
  final DirectionDetails? tripDirectionDetails;
  final VoidCallback onTapRequestRide;

  const RideDetails({
    Key? key,
    required this.rideDetailsContainerHeight,
    required this.tripDirectionDetails,
    required this.onTapRequestRide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
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
                      "Taxi".text.size(18).fontFamily('Brand-Bold').make(),
                      "${tripDirectionDetails != null ? tripDirectionDetails!.distanceText : ''}".text.size(16).color(MyColors.colorTextLight).make(),
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
              onPressed: () => onTapRequestRide(),
              buttonText: 'Request cab',
            ).pSymmetric(h: 16),
          ],
        ).pSymmetric(v: 18),
        ),
      );
  }
}
