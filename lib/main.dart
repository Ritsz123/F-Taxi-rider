import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/LoginScreen.dart';
import 'package:uber_clone/Screens/RegistrationScreen.dart';
import 'package:uber_clone/dataProvider/appData.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      options: Platform.isIOS || Platform.isMacOS
//    for ios
          ? FirebaseOptions(
              appId: '1:297855924061:ios:c6de2b69b03a5be8',
              apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
              projectId: 'flutter-firebase-plugins',
              messagingSenderId: '297855924061',
              databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
            )
//    for android
          : FirebaseOptions(
              appId: '1:532235138800:android:3aa012e24df0217d423435',
              apiKey: 'AIzaSyBGFnI2gX1UKFf3XWBo6uUGCE0HhxKzMlo',
              messagingSenderId: '532235138800',
              projectId: 'uber-clone-ba3b4',
              databaseURL: 'https://uber-clone-ba3b4.firebaseio.com',
            ),
    );
  } catch (ex) {
    print(ex.toString());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Uber clone',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: LoginScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
        },
      ),
    );
  }
}
