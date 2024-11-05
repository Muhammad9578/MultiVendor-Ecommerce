import 'dart:convert';

List<CoursesCart> coursesCartFromJson(String str) => List<CoursesCart>.from(
    json.decode(str).map((x) => CoursesCart.fromJson(x)));

String coursesCartToJson(List<CoursesCart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesCart {
  CoursesCart({
    this.coursesId,
    this.coursesCode,
    this.terms,
    this.title,
    this.merchantId,
    this.startDate,
    this.timeFrom,
    this.timeTo,
    this.fees,
    this.commission,
    this.description,
    this.lecturer,
    this.icon,
    this.banner,
    this.status,
    this.addBy,
    this.dateAdd,
    this.minimum,
    this.maximum,
    this.available,
    this.booked,
    this.timeTable,
    this.quantityItem,
    this.totalPrice,
    this.selected,
    this.merchantName,
    this.merchantImage,
    this.totalDiscount,
    this.priceAfterDiscount,
  });

  String coursesId;
  String coursesCode;
  String terms;
  String title;
  String merchantId;
  DateTime startDate;
  String timeFrom;
  String timeTo;
  String fees;
  String commission;
  String description;
  String lecturer;
  String icon;
  String banner;
  String status;
  DateTime addBy;
  String dateAdd;
  String minimum;
  String maximum;
  String available;
  String booked;
  List<TimeTable> timeTable;
  String merchantName;
  String merchantImage;
  double totalDiscount;
  double priceAfterDiscount;
  int quantityItem = 1;
  double totalPrice;
  bool selected = false;

  factory CoursesCart.fromJson(Map<String, dynamic> json) => CoursesCart(
        coursesId: json["courses_id"],
        coursesCode: json["courses_code"],
        terms: json["terms"],
        title: json["title"],
        merchantId: json["merchant_id"],
        startDate: DateTime.parse(json["start_date"]),
        timeFrom: json["time_from"],
        timeTo: json["time_to"],
        fees: json["fees"],
        commission: json["commission"],
        description: json["description"],
        lecturer: json["lecturer"],
        icon: json["icon"],
        banner: json["banner"],
        status: json["status"],
        addBy: DateTime.parse(json["add_by"]),
        dateAdd: json["date_add"],
        minimum: json["minimum"],
        maximum: json["maximum"],
        available: json["available"],
        booked: json["booked"],
        timeTable: List<TimeTable>.from(
            json["timeTable"].map((x) => TimeTable.fromJson(x))),
        merchantName: json["merchantName"],
        merchantImage: json["merchantImage"],
        totalDiscount: double.parse(json["totalDiscount"]),
        priceAfterDiscount: double.parse(json["priceAfterDiscount"]),
        quantityItem: 1,
        totalPrice: 0,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "courses_id": coursesId,
        "courses_code": coursesCode,
        "terms": terms,
        "title": title,
        "merchant_id": merchantId,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "time_from": timeFrom,
        "time_to": timeTo,
        "fees": fees,
        "commission": commission,
        "description": description,
        "lecturer": lecturer,
        "icon": icon,
        "banner": banner,
        "status": status,
        "add_by": addBy.toIso8601String(),
        "date_add": dateAdd,
        "minimum": minimum,
        "maximum": maximum,
        "available": available,
        "booked": booked,
        "timeTable": List<dynamic>.from(timeTable.map((x) => x.toJson())),
        "merchantName": merchantName,
        "merchantImage": merchantImage,
        "totalDiscount": totalDiscount,
        "priceAfterDiscount": priceAfterDiscount
      };
}

class TimeTable {
  TimeTable({
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

  factory TimeTable.fromJson(Map<String, dynamic> json) => TimeTable(
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
