part of  '../Screens/HomeScreen.dart';

class SearchPanel extends StatelessWidget {
  final double searchContainerHeight;
  final VoidCallback onTapSearch;

  const SearchPanel({
    Key? key,
    required this.searchContainerHeight,
    required this.onTapSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
            "Where are you going".text.size(18).fontFamily('Brand-Bold').make(),
            20.heightBox,
            GestureDetector(
              onTap: () async {
                var screenResponse = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
                if (screenResponse == 'getDirection') {
                  onTapSearch();
                }
              },
              child: Container(
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
                    "Your residential Address".text.size(13).color(MyColors.colorDimText).make(),
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
                    "Your office Address".text.size(13).color(MyColors.colorDimText).make(),
                  ],
                ),
              ],
            ),
          ],
        ).pSymmetric(h: 24, v: 18),
      ),
    );
  }
}
