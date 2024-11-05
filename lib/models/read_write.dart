import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ReadWrite {
  static void write(String text, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName.txt');
    await file.writeAsString(text);
  }

  static Future<String> read(String fileName) async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  static Future deleteFile(fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      await file.delete();
    } catch (e) {
      return 0;
    }
  }
}
