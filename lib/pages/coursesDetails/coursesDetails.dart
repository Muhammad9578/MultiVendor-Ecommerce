import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/models/read_write.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/pages/coursesDetails/service/coursesCart.dart';
import 'package:mos_beauty/pages/coursesDetails/service/coursesDetailsModel.dart';
import 'package:mos_beauty/pages/coursesDetails/service/merchantModel.dart';
import 'package:mos_beauty/pages/listCourses/service/listCoursesModel.dart';
import 'package:mos_beauty/pages/mall/widget/rating_star.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/seeReviews/seeReview.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';

class CoursesDetails extends StatefulWidget {
  final Courses itemCourses;
  final double totalDiscount;
  final double priceAfterDiscount;
  CoursesDetails(this.itemCourses, this.totalDiscount, this.priceAfterDiscount);
  @override
  _CoursesDetailsState createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  bool loading = true;
  List<CoursesArray> coursesDetails = [];
  MerchantInfo merchantData;

  String coursesToJson(Courses data) => json.encode(data.toJson());
  List<CoursesCart> coursesCartFromJson(String str) => List<CoursesCart>.from(
      json.decode(str).map((x) => CoursesCart.fromJson(x)));

  String formatTimeOfDay(TimeOfDay tod, String mode) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format =
        (mode == '24Hour') ? DateFormat.Hm() : DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  //* process add to cart make sure all in json.
  //*  store at storage file in local phone
  _processAddToCart() async {
    String fileName = 'cartCourses';
    // ReadWrite.deleteFile(fileName);
    String dataStorage = await ReadWrite.read(fileName);
    if (dataStorage != null) {
      bool haveDuplicate;
      var checkCoursesDuplicate = coursesCartFromJson(dataStorage);
      for (var u in checkCoursesDuplicate) {
        if (u.coursesId == widget.itemCourses.coursesId) {
          if (this.mounted) {
            setState(() {
              haveDuplicate = true;
            });
          }
          break;
        } else {
          if (this.mounted) {
            setState(() {
              haveDuplicate = false;
            });
          }
        }
      }
      if (dataStorage == '[]') {
        List listCourses = [];
        var courses = coursesToJson(widget.itemCourses);
        listCourses.add(courses);
        print(listCourses);
        ReadWrite.write(listCourses.toString(), fileName);
        _doneAddToCart();
      } else {
        if (haveDuplicate) {
          _alreadyAddToCart();
        } else {
          final jsonDecode = json.decode(dataStorage);
          List newList = [];
          for (var u in jsonDecode) {
            var storageProduct = json.encode(u);
            newList.add(storageProduct);
          }
          var courses = coursesToJson(widget.itemCourses);
          newList.add(courses);
          ReadWrite.write(newList.toString(), fileName);
          _doneAddToCart();
        }
      }
    } else {
      List listCourses = [];
      var courses = coursesToJson(widget.itemCourses);
      listCourses.add(courses);
      print(listCourses);
      ReadWrite.write(listCourses.toString(), fileName);
      _doneAddToCart();
    }
  }

  _alreadyAddToCart() {
    Fluttertoast.showToast(
        msg: "√ Already add to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _doneAddToCart() {
    Fluttertoast.showToast(
        msg: "√ This item done add to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    var jsons = {};
    jsons['coursesId'] = widget.itemCourses.coursesId;
    CoursesDetailsModel().coursesDetailsPhp(jsons).then((value) async {
      MerchantModel.merchantInfoPhp(widget.itemCourses.merchantId)
          .then((value2) {
        if (this.mounted) {
          setState(() {
            coursesDetails = value;
            print(value);
            widget.itemCourses.timeTable = value;
            merchantData = value2;
            widget.itemCourses.merchantName = merchantData.fullName;
            widget.itemCourses.merchantImage = merchantData.image;
            widget.itemCourses.totalDiscount = widget.totalDiscount.toString();
            widget.itemCourses.priceAfterDiscount =
                widget.priceAfterDiscount.toString();
            loading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          widget.itemCourses.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CartPage(),
                  ),
                );
              },
              child: Icon(FontAwesomeIcons.cartPlus,
                  size: 24, color: Colors.black54)),
          SizedBox(width: 30),
        ],
        centerTitle: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                ListView(
                  children: [
                    itemImage(),
                    Stack(
                      children: [
                        contentView(),
                        widget.totalDiscount == 0
                            ? SizedBox()
                            : Positioned(
                                right: 10,
                                child: Container(
                                  height: 180,
                                  width: 38,
                                  child: CustomPaint(
                                    painter: DiscountPainter(),
                                    size: Size(35, 180),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 3),
                                        Text(
                                          "${Format().currency(widget.totalDiscount, decimal: false)}%",
                                          style: TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          "Off",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    merchantView(),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
                Align(alignment: Alignment.bottomCenter, child: bottomWidget())
              ],
            ),
    );
  }

  Container merchantView() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 15),
      height: 180,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://mosbeauty.my/mos/pages/merchant/pic/' +
                              merchantData.image),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      merchantData.fullName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.grey,
                        ),
                        Text(
                          merchantData.address,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  OutlineButton(
                    child: new Text("View Shop",
                        style: TextStyle(color: Colors.pink[300])),
                    borderSide: BorderSide(color: Colors.pink[300], width: 1.0),
                    color: Colors.pink[300],
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ViewShop(
                          merchantId: widget.itemCourses.merchantId,
                        ),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0)),
                  ),
                  // OutlineButton(
                  //   child: new Text("View Shop",
                  //       style: TextStyle(color: Colors.pink[300])),
                  //   borderSide: BorderSide(color: Colors.pink[300], width: 1.0),
                  //   color: Colors.pink[300],
                  //   onPressed: null,
                  //   shape: new RoundedRectangleBorder(
                  //       borderRadius: new BorderRadius.circular(6.0)),
                  // ),
                ],
              ),
              SizedBox(width: 10),
            ],
          ),
          Expanded(child: SizedBox(height: double.infinity)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    merchantData.product,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    "Products",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Container(height: 30, child: VerticalDivider(color: Colors.grey)),
              Column(
                children: [
                  Text(
                    merchantData.service,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    "Service",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Container(height: 30, child: VerticalDivider(color: Colors.grey)),
              Column(
                children: [
                  Text(
                    merchantData.course,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    "Courses",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Container contentView() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      height: 450,
      padding: EdgeInsets.only(left: 10, top: 10, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.itemCourses.title.toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // StarRating(
              //   rating: double.parse(widget.rating),
              //   color: Colors.red,
              //   size: 18,
              // )
            ],
          ),
          SizedBox(height: 8),
          Text(
            widget.itemCourses.terms,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'RM ' +
                Format().currency(
                    widget.priceAfterDiscount == 0
                        ? double.parse(widget.itemCourses.fees)
                        : widget.priceAfterDiscount,
                    decimal: true),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          widget.priceAfterDiscount == 0
              ? SizedBox()
              : StrikeThroughWidget(
                  child: RichText(
                    text: TextSpan(
                      text: 'RM ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '${Format().currency(double.parse(widget.itemCourses.fees), decimal: true)}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          SizedBox(height: 20),
          seeReview(),
          SizedBox(height: 20),
          Divider(
            height: 1,
            color: Colors.grey,
            thickness: 1,
          ),
          SizedBox(height: 20),
          tableCourses(),
        ],
      ),
    );
  }

  Expanded tableCourses() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 600,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateFirstColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: coursesDetails.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: 1.0,
            thickness: 0.0,
          ),
          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  InkWell seeReview() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                SeeReview('courses', widget.itemCourses.coursesId),
          ),
        );
      },
      child: Container(
        height: 45,
        margin: EdgeInsets.only(left: 3, right: 8),
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'SEE REVIEWS',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            StarRating(
              rating: 4.5,
              color: Colors.red,
              size: 18,
            ),
            Text(
              '(2567)',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Container itemImage() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://mosbeauty.my/mos/pages/courses/uploads/' +
                    widget.itemCourses.icon),
            fit: BoxFit.cover),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Date', 100),
      _getTitleItemWidget('Start Time', 100),
      _getTitleItemWidget('End Time', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(DateFormat("dd/MM/yyyy").format(coursesDetails[index].date)),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
            child: Text(formatTimeOfDay(
                TimeOfDay(
                    hour: int.parse(
                        coursesDetails[index].startTime.split(":")[0]),
                    minute: int.parse(
                        coursesDetails[index].startTime.split(":")[1])),
                '12Hour')),
            width: 100,
            height: 52,
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center),
        Container(
          child: Text(formatTimeOfDay(
              TimeOfDay(
                  hour: int.parse(coursesDetails[index].endTime.split(":")[0]),
                  minute:
                      int.parse(coursesDetails[index].endTime.split(":")[1])),
              '12Hour')),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () {
        _processAddToCart();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.only(bottom: 10, left: 30, right: 30),
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[4],
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Icon(FontAwesomeIcons.shoppingBag),
            ),
            Flexible(
              child: Container(
                color: Colors.red[700],
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "ADD TO CART",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
