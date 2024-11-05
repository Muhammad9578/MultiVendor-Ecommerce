import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:mos_beauty/pages/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  final String userId;
  SplashScreen({this.userId});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  removeScreen() {
    return _timer = Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    removeScreen();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: ResponsiveFlutter.of(context).scale(250),
          height: ResponsiveFlutter.of(context).verticalScale(250),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/MOSLogo-01.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
