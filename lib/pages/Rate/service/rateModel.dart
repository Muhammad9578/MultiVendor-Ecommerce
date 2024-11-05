import 'package:flutter/material.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/provider/rest.dart';

class RateModel {
  static Future rateModel(jsons, context) async {
    try {
      showAlertDialogTwoButton(BuildContext context, title) {
        // set up the buttons
        Widget okButton = FlatButton(
          child: Text("Ok", style: TextStyle(color: HexColor('#75DFFF'))),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );

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

      var result = await GetAPI.providers(jsons, 'feedback.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        showAlertDialogTwoButton(context, 'Thank you for your feedback.');
      } else {
        showAlertDialogTwoButton(
            context, 'Failed to request feedback please try again. ');
      }
    } catch (e) {
      print(e);
    }
  }
}
