import 'package:flutter/material.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/provider/rest.dart';
import 'dart:convert';

class CheckoutModel {
  static Future<CheckoutData> checkoutPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'checkout.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        print(response);
        final checkoutData = checkoutDataFromJson(response);
        return checkoutData;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future placeholder(jsons, context) async {
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
      var result = await GetAPI.providers(jsons, 'purchases-place-order.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        showAlertDialogTwoButton(context, 'Successfully Order.');
      } else {
        showAlertDialogTwoButton(context, 'Failed To Order.');
      }
    } catch (e) {
      showAlertDialogTwoButton(context, 'Failed To Order.');
      return null;
    }
  }
}

CheckoutData checkoutDataFromJson(String str) =>
    CheckoutData.fromJson(json.decode(str));

String checkoutDataToJson(CheckoutData data) => json.encode(data.toJson());

class CheckoutData {
  CheckoutData({
    this.grandTotal,
    this.mosCreditBalance,
    this.mosPointBalance,
    this.mosPointToRedeem,
    this.mosPointToRedeemedRm,
  });

  double grandTotal;
  double mosCreditBalance;
  double mosPointBalance;
  double mosPointToRedeem;
  double mosPointToRedeemedRm;

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
        grandTotal: double.parse(json["grand_total"]),
        mosCreditBalance: double.parse(json["mos_credit_balance"]),
        mosPointBalance: double.parse(json["mos_point_balance"]),
        mosPointToRedeem: double.parse(json["mos_point_to_redeem"]),
        mosPointToRedeemedRm: double.parse(json["mos_point_to_redeemed_RM"]),
      );

  Map<String, dynamic> toJson() => {
        "grand_total": grandTotal,
        "mos_credit_balance": mosCreditBalance,
        "mos_point_balance": mosPointBalance,
        "mos_point_to_redeem": mosPointToRedeem,
        "mos_point_to_redeemed_RM": mosPointToRedeemedRm,
      };
}
