import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/LoginScreen.dart';
import 'package:uber_clone/widgets/inputField.dart';
import 'package:uber_clone/widgets/progressIndicator.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:connectivity/connectivity.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registrationScreen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = '';
  String _phone = '';
  String _email = '';
  String _password = '';

  bool isLoading = false;

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
              "Create a rider's account"
                  .text.size(25).fontFamily('Brand-Bold').make(),
              15.heightBox,
              _registrationForm(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                },
                child: "Already have a account?, Login".text.size(15).make(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registrationForm() {
    return Column(
      children: [
        InputField(
          labelText: 'full name',
          onValueChange: (String value) {
            _name = value;
          },
        ),
        10.heightBox,
        InputField(
          labelText: 'Email address',
          onValueChange: (String value) {
            _email = value;
          },
          keyboardType: TextInputType.emailAddress,
        ),
        10.heightBox,
        InputField(
          labelText: 'Phone Number',
          onValueChange: (String value) {
            _phone = value;
          },
          keyboardType: TextInputType.number,
        ),
        10.heightBox,
        InputField(
          labelText: 'Password',
          onValueChange: (String value) {
            _password = value;
          },
          obscureText: true,
        ),
        30.heightBox,
        TaxiButton(
          onPressed: validateRegistration,
          buttonText: "Register",
        ),
      ],
    ).p20();
  }

  void validateRegistration() async {
//                        check network connection
    var connResult = await Connectivity().checkConnectivity();
    if (connResult != ConnectivityResult.mobile &&
        connResult != ConnectivityResult.wifi) {
      showSnackBar("No Internet connectivity");
      return;
    }
    if (_name.length < 5) {
      showSnackBar("Please provide valid full name");
    } else if (_phone.length != 10) {
      showSnackBar("Please provide valid phone number");
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)) {
      showSnackBar("please provide valid email address");
    } else if (_password.length < 6) {
      showSnackBar("password length should be more than 6 characters");
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProgressDialog(status: "Registering user...."),
      );
      registerUser();
    }
  }

  void registerUser() async {
    User? user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(e.message!);
    }

    if (user != null) {
      print('User Registration Successful');
      DatabaseReference newUserRef =
      FirebaseDatabase.instance.reference().child('users/${user.uid}');
//        prepare data to be saved in database
      Map userMap = {
        'fullname': _name,
        'email': _email,
        'phone': _phone,
      };
      await newUserRef.set(userMap);
//        take user to homepage
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.id, (route) => false);
    }
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      elevation: 10,
      content: title.text.size(15).make(),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
