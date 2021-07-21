import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/LoginScreen.dart';
import 'package:uber_clone/globals.dart';
import 'package:uber_clone/helper/helperMethods.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splashScreen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), checkForToken);
    super.initState();
  }

  void checkForToken() async {
    try {
      token = await HelperMethods.getAccessToken();
      logger.i('user already logged in redirecting to home page');
      Navigator.popAndPushNamed(context, HomeScreen.id);

    } catch(e){
      logger.e('user not logged in redirecting to login page');
      Navigator.popAndPushNamed(context, LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.screenHeight,
        width: context.screenWidth,
        color: Colors.black,
        child: 'F - Taxi'.text.size(60).bold.white.makeCentered(),
      ),
    );
  }
}
