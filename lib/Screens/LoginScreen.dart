import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/RegistrationScreen.dart';
import 'package:uber_clone/widgets/progressIndicator.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      elevation: 10,
      content: title.text.size(15).make(),
    );
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  void validateLogin() async {
    var connResult = await Connectivity().checkConnectivity();
    if (connResult != ConnectivityResult.mobile &&
        connResult != ConnectivityResult.wifi) {
      showSnackBar("No Internet connectivity");
      return;
    }
    if (!emailController.text.contains('@')) {
      showSnackBar("Please enter valid email address");
    } else if (passwordController.text.length < 6) {
      showSnackBar("please enter valid password");
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProgressDialog(status: "Logging you in..."),
      );
      loginUser();
    }
  }

  void loginUser() async {
    User? user;
    try {
      user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showSnackBar(e.message!);
    }
    if (user != null) {
//      verify user data in db
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');
      userRef.once().then(
        (DataSnapshot snapshot) {
          if (snapshot != null) {
            print("User Logged in");
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.id, (route) => false);
          }
        },
      );
    }
  }

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
                  .text
                  .size(25)
                  .fontFamily('Brand-Bold')
                  .make(),
              20.heightBox,
              Column(
                children: [
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  10.heightBox,
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  40.heightBox,
                  TaxiButton(
                    onPressed: validateLogin,
                    buttonText: "login",
                  ),
                ],
              ).p20(),
              FlatButton(
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
}
