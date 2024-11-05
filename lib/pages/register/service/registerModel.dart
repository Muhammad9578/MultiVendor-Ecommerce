import 'package:flutter/material.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/provider/rest.dart';

class RegisterModel {
  static registerPhp(jsons, context) async {
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
      var result = await GetAPI.providers(jsons, 'register.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        showAlertDialogTwoButton(
            context, "Registered Successfully, please login ", () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        print(response);
        showAlertDialogTwoButton(
            context, "Registered failed, please try again ", () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
