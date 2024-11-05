class Courses {
  Courses({
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
  List timeTable;
  

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
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
        timeTable: json["timeTable"],
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
        "timeTable": timeTable,
      };
}
