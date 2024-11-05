import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ServiceDetailsModel {
  Future<List<ServicesArray>> servicesDetailsPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'servicesDetails.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final servicesArray = servicesArrayFromJson(response);
        return servicesArray;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ServicesArray> servicesArrayFromJson(String str) =>
    List<ServicesArray>.from(
        json.decode(str).map((x) => ServicesArray.fromJson(x)));

String servicesArrayToJson(List<ServicesArray> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesArray {
  ServicesArray({
    this.serviceSessionId,
    this.serviceId,
    this.day,
    this.time,
    this.quantityPerSession,
    this.available,
    this.booked,
    this.selectedMe,
    this.whyMeSelected,
  });

  String serviceSessionId;
  String serviceId;
  String day;
  String time;
  String quantityPerSession;
  String available;
  String booked;
  int selectedMe;
  int whyMeSelected;

  factory ServicesArray.fromJson(Map<String, dynamic> json) => ServicesArray(
        serviceSessionId: json["service_session_id"],
        serviceId: json["service_id"],
        day: json["day"],
        time: json["time"],
        quantityPerSession: json["quantity_per_session"],
        available: json["available"],
        booked: json["booked"],
        selectedMe: json["selectedMe"],
        whyMeSelected: 0,
      );

  Map<String, dynamic> toJson() => {
        "service_session_id": serviceSessionId,
        "service_id": serviceId,
        "day": day,
        "time": time,
        "quantity_per_session": quantityPerSession,
        "available": available,
        "booked": booked,
        "selectedMe": selectedMe,
      };
}
