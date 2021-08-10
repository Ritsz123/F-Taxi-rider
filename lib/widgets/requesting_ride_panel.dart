part of  '../Screens/HomeScreen.dart';

class RequestingRidePanel extends StatelessWidget {
  final double requestingRideContainerHeight;
  final VoidCallback onCancelRide;

  const RequestingRidePanel({
    Key? key,
    required this.requestingRideContainerHeight,
    required this.onCancelRide
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
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
              onTap: () => onCancelRide(),
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
    );
  }
}
