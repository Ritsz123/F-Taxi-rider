import 'package:flutter/material.dart';
import 'package:uber_clone/styles/styles.dart';
import 'package:uber_clone/widgets/divider.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/user_icon.png',
                  height: 60,
                  width: 60,
                ),
                35.widthBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "Ritesh Khadse"
                        .text
                        .size(20)
                        .fontFamily('Brand-Bold')
                        .make(),
                    "View Profile".text.make(),
                  ],
                ),
              ],
            ),
          ),
          MyDivider(),
          10.heightBox,
          ListTile(
            leading: Icon(
              Icons.card_giftcard_outlined,
              size: kDrawerItemIconSize,
            ),
            title: Text(
              "Free Rides",
              style: kDrawerItemTextStyle,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.credit_card_outlined,
              size: kDrawerItemIconSize,
            ),
            title: Text(
              "Payments",
              style: kDrawerItemTextStyle,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              size: kDrawerItemIconSize,
            ),
            title: Text(
              "Ride History",
              style: kDrawerItemTextStyle,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.contact_support_outlined,
              size: kDrawerItemIconSize,
            ),
            title: Text(
              "Support",
              style: kDrawerItemTextStyle,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              size: kDrawerItemIconSize,
            ),
            title: Text(
              "About",
              style: kDrawerItemTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}