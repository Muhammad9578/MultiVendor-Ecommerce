import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class FollowModel{
  static Future followPhp(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'follow.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {

        final map = json.decode(response);
        print("reposnse ${response.substring(response.indexOf(":"),response.lastIndexOf(",")).replaceAll(":","")}");

        return "${response.substring(response.indexOf(":"),response.lastIndexOf(",")).replaceAll(":","")}";

      }
    }
    catch (e) {
      print(e);
    }
  }
}