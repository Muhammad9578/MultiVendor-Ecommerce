import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class FollowerModel{
  static Future followerPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons,'followers.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {

        final map = json.decode(response);
        print("response at follower $response");

        return "$map";

      }
    }
    catch (e) {
      print(e);
    }
  }
}