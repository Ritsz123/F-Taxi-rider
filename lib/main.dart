import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/Screens/HomeScreen.dart';
import 'package:uber_clone/Screens/LoginScreen.dart';
import 'package:uber_clone/Screens/RegistrationScreen.dart';
import 'package:uber_clone/Screens/SplashScreen.dart';
import 'package:uber_clone/dataProvider/appData.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      options: FirebaseOptions(
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
        title: 'F Taxi',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SplashScreen.id,
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          SplashScreen.id: (context) => SplashScreen(),
        },
      ),
    );
  }
}
