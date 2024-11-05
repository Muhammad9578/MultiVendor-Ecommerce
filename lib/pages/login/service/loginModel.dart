import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/pages/home_page.dart';
import 'package:mos_beauty/provider/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel {
  static Future loginPhp(jsons, context) async {
    showAlertDialogTwoButton(BuildContext context, title, Function onPressed) {
      // set up the buttons
      Widget okButton = FlatButton(
          child: Text("Ok", style: TextStyle(color: HexColor('#75DFFF'))),
          onPressed: onPressed);

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        content: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    try {
      var result = await GetAPI.providers(jsons, 'login.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final map = json.decode(response);


        // print("Login MOdel  $response   and  result $result    amd map $map");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = map["userId"];
        var userName = map["user_name"];
        var userType = map["user_type"];
        var fullName = map["full_name"];
        var image = map["image"];
        var status = map["status"];
        var contactNo = map["contact_no"];
        var email = map["email"];
        var token = map["token"];
        GetAPI.setupHTTPHeader(token);
        prefs.setString("userId", userId);
        prefs.setString("userName", userName);
        prefs.setString("userType", userType);
        prefs.setString("fullName", fullName);
        prefs.setString("image", image);
        prefs.setString("status", status);
        prefs.setString("contactNo", contactNo);
        prefs.setString("email", email);
        prefs.setString("token", token);
        showAlertDialogTwoButton(context, 'Successfully login ✓', () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => HomePage(userId),
        //   ),
        // );
        return false;
      } else {
        showAlertDialogTwoButton(
            context, 'Your username and password is incorrect', () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
