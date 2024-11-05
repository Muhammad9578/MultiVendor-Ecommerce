import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class WalletPointModel {
  Future eWalletUserPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'ewallet-user.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final servicesCart = walletUserFromJson(response);
        return servicesCart;
      } else {
        final servicesCart = walletUserFromJson(response);
        return servicesCart;
      }
    } catch (e) {
      print(e);
    }
  }
}

WalletUser walletUserFromJson(String str) =>
    WalletUser.fromJson(json.decode(str));

String walletUserToJson(WalletUser data) => json.encode(data.toJson());

class WalletUser {
  WalletUser({
    this.mosPoint,
    this.memberId,
    this.transactionHistory,
  });

  double mosPoint;
  String memberId;
  List<TransactionHistory> transactionHistory;

  factory WalletUser.fromJson(Map<String, dynamic> json) => WalletUser(
        mosPoint: json["mosPoint"] == null ? null : json["mosPoint"].toDouble(),
        memberId: json["memberID"] == null ? null : json["memberID"],
        transactionHistory: json["transactionHistory"] == null
            ? null
            : List<TransactionHistory>.from(json["transactionHistory"]
                .map((x) => TransactionHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mosPoint": mosPoint == null ? null : mosPoint,
        "memberID": memberId == null ? null : memberId,
        "transactionHistory": transactionHistory == null
            ? null
            : List<dynamic>.from(transactionHistory.map((x) => x.toJson())),
      };
}

class TransactionHistory {
  TransactionHistory({
    this.mosPointId,
    this.referType,
    this.currentPoint,
    this.datetime,
    this.action,
  });

  String mosPointId;
  String referType;
  String currentPoint;
  DateTime datetime;
  String action;

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        mosPointId: json["mos_point_id"] == null ? null : json["mos_point_id"],
        referType: json["refer_type"] == null ? null : json["refer_type"],
        currentPoint:
            json["current_point"] == null ? null : json["current_point"],
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        action: json["action"] == null ? null : json["action"],
      );

  Map<String, dynamic> toJson() => {
        "mos_point_id": mosPointId == null ? null : mosPointId,
        "refer_type": referType == null ? null : referType,
        "current_point": currentPoint == null ? null : currentPoint,
        "datetime": datetime == null ? null : datetime.toIso8601String(),
        "action": action == null ? null : action,
      };
}
