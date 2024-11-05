import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mos_beauty/provider/globals.dart' as globals;

class GetAPI {
  static setupHTTPHeader(token) {
    globals.headers = {
      'Content-Type': 'application/json',
      'X-Authorization': 'Bearer $token',
    };
  }

  static providers(jsons, phpFile) async {
    String api = 'https://mosbeauty.my/mos.api/api/';
    jsons["authKey"] = "key123"; 
    String jsonBody = json.encode(jsons);


    try {
      String url = '$api$phpFile';
      Response response =
          await post(Uri.parse(url), headers: globals.headers, body: jsonBody);

      return [response.statusCode, response.body];
    } catch (e) {
      print(e);
      return e;
    }
  }
}
