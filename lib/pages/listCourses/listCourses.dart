import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/pages/coursesDetails/coursesDetails.dart';
import 'package:mos_beauty/pages/listCourses/service/discountModel.dart';
import 'package:mos_beauty/pages/listCourses/service/listCoursesModel.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/utils/format.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';

class ListCourses extends StatefulWidget {
  final List coursesFromListOrder;
  final String coursesCategoryId;
  ListCourses({@required this.coursesFromListOrder, this.coursesCategoryId});
  @override
  _ListCoursesState createState() => _ListCoursesState();
}

class _ListCoursesState extends State<ListCourses> {
  List<Courses> listCourses = [];
  List<DiscountCourses> discountCourses = [];
  bool loading = true;

  final borderField = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    var jsons = {};
    if (widget.coursesCategoryId == null) {
      jsons["typeProduct"] = "courses";
      jsons["isFromCategory"] = false;
    } else {
      jsons["typeProduct"] = "courses";
      jsons["courses_category_id"] = widget.coursesCategoryId;
      jsons["isFromCategory"] = true;
    }
    ListCoursesModel.listProductPhp(jsons, context).then((value) {
      print(value);
      if (value.isNotEmpty) {
        DiscountModel.discountPhp(jsons).then((value2) {
          if (this.mounted) {
            setState(() {
              listCourses = value;
              discountCourses = value2;
              if (widget.coursesFromListOrder.isNotEmpty) {
                pushPageFromProductOrder(discountCourses);
              } else {
                loading = false;
              }
            });
          }
        });
      } else {
        if (this.mounted) {
          setState(() {
            listCourses = value;
            if (widget.coursesFromListOrder.isNotEmpty) {
              pushPageFromProductOrder(null);
            } else {
              loading = false;
            }
          });
        }
      }
    });
    super.initState();
  }

  pushPageFromProductOrder(getDataDiscount) {
    if (getDataDiscount != null) {
      listCourses.forEach((item) {
        if (item.coursesId == widget.coursesFromListOrder[0]) {
          double discount = 0;
          for (var u in discountCourses) {
            if (u.itemId == widget.coursesFromListOrder[0]) {
              discount = double.parse(u.discountOff);
              break;
            }
          }
          double totalDiscount = double.parse(item.fees) -
              (double.parse(item.fees) * discount / 100);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  CoursesDetails(item, discount, totalDiscount),
            ),
          ).then((value) {
            setState(() {
              loading = false;
            });
          });
        }
      });
    } else {
      listCourses.forEach((item) {
        if (item.coursesId == widget.coursesFromListOrder[0]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CoursesDetails(item, 0, 0),
            ),
          ).then((value) {
            setState(() {
              loading = false;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          height: 40,
          child: TextField(
            decoration: new InputDecoration(
              suffixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              focusColor: Colors.grey,
              hoverColor: Colors.grey,
              focusedErrorBorder: borderField,
              errorBorder: borderField,
              disabledBorder: borderField,
              border: borderField,
              enabledBorder: borderField,
              focusedBorder: borderField,
            ),
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listCourses.isEmpty
                ? Center(
                    child: Text(
                      'No item list found.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey,
                          letterSpacing: 2),
                    ),
                  )
                : GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: listCourses.length,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.2),
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      bool haveTrue = false;
                      double discount = 0;
                      final item = listCourses[index];
                      for (var u in discountCourses) {
                        if (u.itemId == item.coursesId) {
                          discount = double.parse(u.discountOff);
                          haveTrue = true;
                          break;
                        } else {
                          haveTrue = false;
                        }
                      }
                      if (haveTrue) {
                        //* this is for discount ui
                        double totalDiscount = double.parse(item.fees) -
                            (double.parse(item.fees) * discount / 100);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CoursesDetails(
                                        item, discount, totalDiscount),
                              ),
                            );
                          },
                          child: GridTile(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(
                                    color: Colors.blueGrey, width: 0.5),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Image.network(
                                            'https://mosbeauty.my/mos/pages/courses/uploads/' +
                                                item.icon,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
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
                                                    "${Format().currency(discount, decimal: false)}%",
                                                    style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Off",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, top: 3),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.description,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              item.lecturer,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 13.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              'RM ' +
                                                  Format().currency(
                                                      totalDiscount,
                                                      decimal: true),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            StrikeThroughWidget(
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
                                                          '${Format().currency(double.parse(item.fees), decimal: true)}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // StarRating(
                                            //   rating: 3.5,
                                            //   color: Colors.red,
                                            //   size: 18,
                                            // )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CoursesDetails(item, 0, 0),
                              ),
                            );
                          },
                          child: GridTile(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(
                                    color: Colors.blueGrey, width: 0.5),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        'https://mosbeauty.my/mos/pages/courses/uploads/' +
                                            item.icon,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 8, top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              item.lecturer,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 13.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              'RM ' +
                                                  Format().currency(
                                                      double.parse(item.fees),
                                                      decimal: true),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // StarRating(
                                            //   rating: 3.5,
                                            //   color: Colors.red,
                                            //   size: 18,
                                            // )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
      ),
    );
  }
}
