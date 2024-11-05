import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mos_beauty/pages/home_page.dart';
import 'package:mos_beauty/provider/rest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Theme/yommie_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('userId');
  var firstName = prefs.getString('firstname');
  var email = prefs.getString('email');
  GetAPI.setupHTTPHeader(prefs.getString('token'));
  runApp(MyApp(
    userId: prefs.getString('userId'),
  ));
}

class MyApp extends StatelessWidget {
  final String userId;

  MyApp({this.userId});



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'MOS Beauty',
      theme: YommieTheme.buildLightTheme(),
      debugShowCheckedModeBanner: false,
      home: HomePage(userId),
      // userId == null
      //     ? SplashScreen(
      //         userId: userId,
      //       )
      //     : HomePage(userId),
    );
  }
}
