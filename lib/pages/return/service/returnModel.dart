import 'package:flutter/material.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/provider/rest.dart';

class ReturnModel {
  static Future returnModel(jsons, context) async {
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

    try {
      var result = await GetAPI.providers(jsons, 'purchases-return-order.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        showAlertDialogTwoButton(context,
            'Your request for return / refund / dispute is processing.');
      } else {
        showAlertDialogTwoButton(context,
            'Failed to request return / refund / dispute order. Please Try Again Later.');
      }
    } catch (e) {}
  }
}
