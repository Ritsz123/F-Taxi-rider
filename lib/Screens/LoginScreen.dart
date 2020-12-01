import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/RegistrationScreen.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatelessWidget {
  static const String id = "loginScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TaxiButton(onPressed: () {}, buttonText: "login"),
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
