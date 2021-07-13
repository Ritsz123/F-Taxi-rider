import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/RegistrationScreen.dart';
import 'package:uber_clone/helper/requestHelper.dart';
import 'package:uber_clone/widgets/inputField.dart';
import 'package:uber_clone/widgets/progressIndicator.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:uber_clone/serviceUrls.dart' as serviceUrl;

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              70.heightBox,
              Image(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                image: AssetImage("assets/images/logo.png"),
              ),
              20.heightBox,
              "Sign in as a rider"
                  .text.size(25).fontFamily('Brand-Bold').make(),
              20.heightBox,
              Column(
                children: [
                  _loginForm(),
                  40.heightBox,
                  TaxiButton(
                    onPressed: processLogin,
                    buttonText: "login",
                  ),
                ],
              ).p20(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.id, (route) => false);
                },
                child:
                    "Don't have a account, sign up here".text.size(15).make(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      children: [
        InputField(
          onValueChange: (String value) {
            _email = value;
          },
          keyboardType: TextInputType.emailAddress,
          labelText: 'Email Address',
        ),
        15.heightBox,
        InputField(
          onValueChange: (String value) {
            _password = value;
          },
          obscureText: true,
          labelText: 'Password',
        ),
      ],
    );
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      elevation: 10,
      content: title.text.size(15).make(),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  Future<bool> _validateLoginForm() async {
    var connResult = await Connectivity().checkConnectivity();
    if (connResult != ConnectivityResult.mobile &&
        connResult != ConnectivityResult.wifi) {
      showSnackBar("No Internet connectivity");
      return false;
    }

    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
      showSnackBar('Invalid email');
      return false;
    }else if (_password.length < 6) {
      showSnackBar("please enter valid password");
      return false;
    }
    return true;
  }

  void processLogin() async {
    bool isFormValid = await _validateLoginForm();
    if(!isFormValid) return;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ProgressDialog(status: "Logging you in..."),
    );

    try {
      Map<String, dynamic> response = await RequestHelper.postRequest(
        url: serviceUrl.registerUser,
        body: {
          'email' : _email,
          'password' : _password,
        },
      );

      //TODO: cache token response

      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    } catch (e) {
      Navigator.pop(context);
      showSnackBar(e.toString());
    }
  }

}
