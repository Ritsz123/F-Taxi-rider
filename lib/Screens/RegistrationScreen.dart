import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/Screens/LoginScreen.dart';
import 'package:uber_clone/widgets/taxiButton.dart';
import 'package:velocity_x/velocity_x.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = "registrationScreen";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void registerUser() async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;
      if (user != null) {
        print('Registration Successful');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      elevation: 10,
      content: title.text.size(15).make(),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
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
              "Create a rider's account"
                  .text
                  .size(25)
                  .fontFamily('Brand-Bold')
                  .make(),
              15.heightBox,
              Column(
                children: [
                  TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  5.heightBox,
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  5.heightBox,
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  5.heightBox,
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  30.heightBox,
                  TaxiButton(
                      onPressed: () {
                        if (fullNameController.text.length < 5) {
                          showSnackBar("Please provide valid full name");
                        } else if (phoneController.text.length != 10) {
                          showSnackBar("Please provide valid phone number");
                        } else if (!emailController.text.contains('@')) {
                          showSnackBar("please provide valid email address");
                        } else if (passwordController.text.length < 6) {
                          showSnackBar(
                              "password length should be more than 6 characters");
                        } else {
                          registerUser();
                        }
                      },
                      buttonText: "Register"),
                ],
              ).p20(),
              FlatButton(
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
}
