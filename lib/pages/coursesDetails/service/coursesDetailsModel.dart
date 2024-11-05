import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class CoursesDetailsModel {
  Future<List<CoursesArray>> coursesDetailsPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'coursesDetails.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final coursesArray = coursesArrayFromJson(response);
        return coursesArray;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<CoursesArray> coursesArrayFromJson(String str) => List<CoursesArray>.from(
    json.decode(str).map((x) => CoursesArray.fromJson(x)));

String coursesArrayToJson(List<CoursesArray> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesArray {
  CoursesArray({
    this.coursesTimetableId,
    this.coursesId,
    this.date,
    this.startTime,
    this.endTime,
  });

  String coursesTimetableId;
  String coursesId;
  DateTime date;
  String startTime;
  String endTime;

  factory CoursesArray.fromJson(Map<String, dynamic> json) => CoursesArray(
        coursesTimetableId: json["courses_timetable_id"],
        coursesId: json["courses_id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "courses_timetable_id": coursesTimetableId,
        "courses_id": coursesId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
      };
}
