import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/models/read_write.dart';
import 'package:mos_beauty/pages/checkout/checkout_page.dart';
import 'package:mos_beauty/pages/coursesDetails/service/coursesCart.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/productDetails/service/productArray.dart';
import 'package:mos_beauty/pages/servicesDetails/service/sevicesCart.dart';
import 'package:mos_beauty/utils/format.dart';
import 'package:mos_beauty/utils/listCourses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListToPay extends StatefulWidget {
  @override
  _ListToPayState createState() => _ListToPayState();
}

class _ListToPayState extends State<ListToPay> {
  List<ProductArray> productArrayFromJson(String str) =>
      List<ProductArray>.from(
          json.decode(str).map((x) => ProductArray.fromJson(x)));
  String productArrayToJson(List<ProductArray> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  List<CoursesCart> coursesCartFromJson(String str) => List<CoursesCart>.from(
      json.decode(str).map((x) => CoursesCart.fromJson(x)));
  String coursesCartToJson(List<CoursesCart> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  List<ServicesCart> servicesCartFromJson(String str) =>
      List<ServicesCart>.from(
          json.decode(str).map((x) => ServicesCart.fromJson(x)));
  String servicesCartToJson(List<ServicesCart> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  List<ProductArray> product = [];
  List<CoursesCart> courses = [];
  List<ServicesCart> services = [];

  List<ProductArray> selectedItem = [];
  List<CoursesCart> selectedCourses = [];
  List<ServicesCart> selectedServices = [];
  double grandTotal = 0;
  List column = [];

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  refreshData() {
    ReadWrite.read('cart').then((value) {
      if (value != null) {
        print(value);
        final productCart = productArrayFromJson(value);
        if (this.mounted) {
          setState(() {
            product = productCart;
          });
        }
      } else {}
    });
    ReadWrite.read('cartCourses').then((value) {
      if (value != null) {
        final coursesCart = coursesCartFromJson(value);
        if (this.mounted) {
          setState(() {
            courses = coursesCart;
          });
        }
      } else {}
    });
    ReadWrite.read('cartServices').then((value) {
      if (value != null) {
        final servicesCart = servicesCartFromJson(value);
        if (this.mounted) {
          setState(() {
            services = servicesCart;
          });
        }
      } else {}
    });
  }

  void _deleteProcess(ProductArray item) {
    if (this.mounted) {
      setState(() {
        selectedItem.removeWhere((items) => items.productId == item.productId);
        product.removeWhere((items) => items.productId == item.productId);
      });
    }

    final productToJson = productArrayToJson(product);
    ReadWrite.write(productToJson, 'cart');
  }

  void _deleteProcessCourses(CoursesCart item) {
    if (this.mounted) {
      setState(() {
        selectedCourses
            .removeWhere((items) => items.coursesId == item.coursesId);
        courses.removeWhere((items) => items.coursesId == item.coursesId);
      });
    }

    final coursesToJson = coursesCartToJson(courses);
    ReadWrite.write(coursesToJson, 'cartCourses');
  }

  void _deleteProcessService(ServicesCart item) {
    if (this.mounted) {
      setState(() {
        selectedServices
            .removeWhere((items) => items.serviceId == item.serviceId);
        services.removeWhere((items) => items.serviceId == item.serviceId);
      });
    }

    final servicesToJson = servicesCartToJson(services);
    ReadWrite.write(servicesToJson, 'cartServices');
  }

  _updateSelectedItem(dynamic item) {
    if (item.selected) {
      setState(() {
        grandTotal = 0;
      });
      _calculateGrandTotal();
    }
  }

  //* calculate for grand total
  _calculateGrandTotal() {
    for (ProductArray item in selectedItem) {
      if (item.totalPrice == 0.0) {
        setState(() {
          //* priceAfterDiscount == 0 is mean this item does not have discount
          if (item.priceAfterDiscount == 0) {
            grandTotal += double.parse(item.price);
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      } else {
        setState(() {
          if (item.priceAfterDiscount == 0) {
            grandTotal += item.totalPrice;
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      }
    }
    for (CoursesCart item in selectedCourses) {
      if (item.totalPrice == 0.0) {
        setState(() {
          if (item.priceAfterDiscount == 0) {
            grandTotal += double.parse(item.fees);
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      } else {
        setState(() {
          if (item.priceAfterDiscount == 0) {
            grandTotal += item.totalPrice;
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      }
    }
    for (ServicesCart item in selectedServices) {
      if (item.totalPrice == 0.0) {
        setState(() {
          if (item.priceAfterDiscount == 0) {
            grandTotal += double.parse(item.cost);
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      } else {
        setState(() {
          if (item.priceAfterDiscount == 0) {
            grandTotal += item.totalPrice;
          } else {
            grandTotal += item.priceAfterDiscount;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return product.isNotEmpty || courses.isNotEmpty || services.isNotEmpty
        ? Stack(
            children: [
              ListView(
                children: [
                  product.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  product.isNotEmpty ? titleItem('PRODUCT') : SizedBox(),
                  product.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  productNewListMethod(),
                  courses.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  courses.isNotEmpty ? titleItem('COURSES') : SizedBox(),
                  courses.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  coursesListMethod(),
                  services.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  services.isNotEmpty ? titleItem('SERVICE') : SizedBox(),
                  services.isNotEmpty ? SizedBox(height: 30) : SizedBox(),
                  servicesListMethod(),
                  selectedItem.isNotEmpty ||
                          selectedServices.isNotEmpty ||
                          selectedCourses.isNotEmpty
                      ? SizedBox(height: 80)
                      : SizedBox(
                          height: 20,
                        ),
                ],
              ),
              selectedItem.isNotEmpty ||
                      selectedServices.isNotEmpty ||
                      selectedCourses.isNotEmpty
                  ? Align(
                      alignment: Alignment.bottomCenter, child: bottomWidget())
                  : SizedBox()
            ],
          )
        : Center(
            child: Text('No Order Yet',
                style: TextStyle(color: Colors.blueGrey, letterSpacing: 2)),
          );
  }

  Padding titleItem(title) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 10),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  //! =============== LIST OF SERVICES ======================
  Widget servicesListMethod() {
    return Column(
      children: services.map((item) {
        return Container(
          height: 200,
          padding: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: Card(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(!item.selected
                      ? Icons.check_box_outline_blank
                      : Icons.check_box),
                  onPressed: () {
                    setState(() {
                      grandTotal = 0;
                      item.selected
                          ? item.selected = false
                          : item.selected = true;
                    });
                    if (item.selected) {
                      selectedServices.add(item);
                      _calculateGrandTotal();
                    } else {
                      selectedServices.removeWhere(
                          (items) => items.serviceId == item.serviceId);
                      _calculateGrandTotal();
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        width: double.infinity,
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '3-7 Day after service done customer can review & comment. Review lower than 3 star will be hide',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteProcessService(item);
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 100,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://mosbeauty.my/mos/pages/service/uploads/' +
                                          item.image,
                                  // errorWidget: (context, url, error) =>
                                  //     Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                                            item.merchantImage),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                item.merchantName,
                                              ),
                                            ),
                                            ButtonTheme(
                                              minWidth: 10.0,
                                              height: 30.0,
                                              child: RaisedButton(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                  side: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  "View Shop",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (item.quantityItem > 1) {
                                                  item.quantityItem--;
                                                  item.totalPrice =
                                                      double.parse(item.cost) *
                                                          item.quantityItem;
                                                  if (item.priceAfterDiscount !=
                                                      0) {
                                                    item.priceAfterDiscount = item
                                                            .totalPrice -
                                                        (item.totalPrice *
                                                            item.totalDiscount /
                                                            100);
                                                  }
                                                  _updateSelectedItem(item);
                                                } else {
                                                  print('MAX');
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                              '${item.quantityItem.toString()}'),
                                          SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                item.quantityItem++;
                                                item.totalPrice =
                                                    double.parse(item.cost) *
                                                        item.quantityItem;
                                                if (item.priceAfterDiscount !=
                                                    0) {
                                                  item.priceAfterDiscount = item
                                                          .totalPrice -
                                                      (item.totalPrice *
                                                          item.totalDiscount /
                                                          100);
                                                }
                                                _updateSelectedItem(item);
                                              });
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  //* check kosong for tahu price itu ada discount atau tidak.
                                                  item.priceAfterDiscount == 0
                                                      ? item.totalPrice != 0
                                                          ? Text('RM ' +
                                                              Format().currency(
                                                                  item
                                                                      .totalPrice,
                                                                  decimal:
                                                                      true))
                                                          : Text('RM ' +
                                                              Format().currency(
                                                                  double.parse(
                                                                      item
                                                                          .cost),
                                                                  decimal:
                                                                      true))
                                                      : Text(
                                                          'RM ' +
                                                              Format().currency(
                                                                  item.priceAfterDiscount == 0
                                                                      ? item
                                                                          .totalPrice
                                                                      : item
                                                                          .priceAfterDiscount,
                                                                  decimal:
                                                                      true),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                  item.priceAfterDiscount == 0
                                                      ? SizedBox()
                                                      : StrikeThroughWidget(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: 'RM ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.cost), decimal: true)}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  //! =============== LIST OF COURSES ======================
  Widget coursesListMethod() {
    return Column(
      children: courses.map((CoursesCart item) {
        return Container(
          height: 200,
          padding: EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          child: Card(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(!item.selected
                      ? Icons.check_box_outline_blank
                      : Icons.check_box),
                  onPressed: () {
                    setState(() {
                      grandTotal = 0;
                      item.selected
                          ? item.selected = false
                          : item.selected = true;
                    });
                    if (item.selected) {
                      selectedCourses.add(item);
                      _calculateGrandTotal();
                    } else {
                      selectedCourses.removeWhere(
                          (items) => items.coursesId == item.coursesId);
                      _calculateGrandTotal();
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        width: double.infinity,
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '3-7 Day after service done customer can review & comment. Review lower than 3 star will be hide',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteProcessCourses(item);
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 100,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://mosbeauty.my/mos/pages/courses/uploads/' +
                                          item.icon,
                                  // errorWidget: (context, url, error) =>
                                  //     Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                                            item.merchantImage),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                item.merchantName,
                                              ),
                                            ),
                                            ButtonTheme(
                                              minWidth: 10.0,
                                              height: 30.0,
                                              child: RaisedButton(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.0),
                                                  side: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  "View Shop",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Divider(
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.title}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //* tolak quantity
                                              //* quantity 0 ask for remove to user
                                              setState(() {
                                                if (item.quantityItem > 1) {
                                                  item.quantityItem--;
                                                  item.totalPrice =
                                                      double.parse(item.fees) *
                                                          item.quantityItem;
                                                  if (item.priceAfterDiscount !=
                                                      0) {
                                                    item.priceAfterDiscount = item
                                                            .totalPrice -
                                                        (item.totalPrice *
                                                            item.totalDiscount /
                                                            100);
                                                  }
                                                  _updateSelectedItem(item);
                                                } else {
                                                  print('MAX');
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                              '${item.quantityItem.toString()}'),
                                          SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              //* tambah quantity
                                              //* quantity 0 ask for remove to user
                                              setState(() {
                                                item.quantityItem++;
                                                item.totalPrice =
                                                    double.parse(item.fees) *
                                                        item.quantityItem;
                                                if (item.priceAfterDiscount !=
                                                    0) {
                                                  item.priceAfterDiscount = item
                                                          .totalPrice -
                                                      (item.totalPrice *
                                                          item.totalDiscount /
                                                          100);
                                                }
                                                _updateSelectedItem(item);
                                              });
                                            },
                                            child: Container(
                                              width: 25.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      ),
                                      // itemPriceCourses(item),
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  //* check kosong for tahu price itu ada discount atau tidak.
                                                  item.priceAfterDiscount == 0
                                                      ? item.totalPrice != 0
                                                          ? Text('RM ' +
                                                              Format().currency(
                                                                  item
                                                                      .totalPrice,
                                                                  decimal:
                                                                      true))
                                                          : Text('RM ' +
                                                              Format().currency(
                                                                  double.parse(
                                                                      item
                                                                          .fees),
                                                                  decimal:
                                                                      true))
                                                      : Text(
                                                          'RM ' +
                                                              Format().currency(
                                                                  item.priceAfterDiscount == 0
                                                                      ? item
                                                                          .totalPrice
                                                                      : item
                                                                          .priceAfterDiscount,
                                                                  decimal:
                                                                      true),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                  item.priceAfterDiscount == 0
                                                      ? SizedBox()
                                                      : StrikeThroughWidget(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: 'RM ',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.fees), decimal: true)}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  //! =============== LIST OF PRODUCT ======================
  Widget productNewListMethod() {
    return Column(
      children: product
          .map(
            (item) => Container(
              height: 200,
              padding: EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(!item.selected
                          ? Icons.check_box_outline_blank
                          : Icons.check_box),
                      onPressed: () {
                        setState(() {
                          grandTotal = 0;
                          item.selected
                              ? item.selected = false
                              : item.selected = true;
                        });
                        if (item.selected) {
                          selectedItem.add(item);
                          _calculateGrandTotal();
                        } else {
                          selectedItem.removeWhere(
                              (items) => items.productId == item.productId);
                          _calculateGrandTotal();
                        }
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: double.infinity,
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '3-7 Day after service done customer can review & comment. Review lower than 3 star will be hide',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteProcess(item);
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    height: 100,
                                    width: 80,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://mosbeauty.my/mos/pages/product/uploads/' +
                                              item.picture,
                                      // errorWidget: (context, url, error) =>
                                      //     Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                                                item.merchantImage),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    item.merchantName,
                                                  ),
                                                ),
                                                ButtonTheme(
                                                  minWidth: 10.0,
                                                  height: 30.0,
                                                  child: RaisedButton(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.0),
                                                      side: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                    onPressed: () {},
                                                    child: Text(
                                                      "View Shop",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Divider(
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item.name}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (item.quantityItem > 1) {
                                                      item.quantityItem--;
                                                      item.totalPrice =
                                                          double.parse(
                                                                  item.price) *
                                                              item.quantityItem;
                                                      if (item.priceAfterDiscount !=
                                                          0) {
                                                        item.priceAfterDiscount = item
                                                                .totalPrice -
                                                            (item.totalPrice *
                                                                item.totalDiscount /
                                                                100);
                                                      }
                                                      _updateSelectedItem(item);
                                                    } else {
                                                      print('MAX');
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: 25.0,
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                  '${item.quantityItem.toString()}'),
                                              SizedBox(width: 8),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    item.quantityItem++;
                                                    item.totalPrice =
                                                        double.parse(
                                                                item.price) *
                                                            item.quantityItem;
                                                    if (item.priceAfterDiscount !=
                                                        0) {
                                                      item.priceAfterDiscount =
                                                          item.totalPrice -
                                                              (item.totalPrice *
                                                                  item.totalDiscount /
                                                                  100);
                                                    }
                                                    _updateSelectedItem(item);
                                                  });
                                                },
                                                child: Container(
                                                  width: 25.0,
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //* check kosong for tahu price itu ada discount atau tidak.
                                                      item.priceAfterDiscount ==
                                                              0
                                                          ? item.totalPrice != 0
                                                              ? Text('RM ' +
                                                                  Format().currency(
                                                                      item
                                                                          .totalPrice,
                                                                      decimal:
                                                                          true))
                                                              : Text('RM ' +
                                                                  Format().currency(
                                                                      double.parse(item
                                                                          .price),
                                                                      decimal:
                                                                          true))
                                                          : Text(
                                                              'RM ' +
                                                                  Format().currency(
                                                                      item.priceAfterDiscount == 0
                                                                          ? item
                                                                              .totalPrice
                                                                          : item
                                                                              .priceAfterDiscount,
                                                                      decimal:
                                                                          true),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                      item.priceAfterDiscount ==
                                                              0
                                                          ? SizedBox()
                                                          : StrikeThroughWidget(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  text: 'RM ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.price), decimal: true)}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userId = prefs.getString('userId');
        if (userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CheckOutPage(
                selectedItem: selectedItem,
                selectedCourses: selectedCourses,
                selectedServices: selectedServices,
                grandTotal: grandTotal,
              ),
            ),
          ).then((value) => refreshData());
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        }
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                color: Colors.red,
                width: 190,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.cartArrowDown,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "SubTotal",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                'RM ' + Format().currency(grandTotal, decimal: true),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row itemPrice(ProductArray item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Total'),
        SizedBox(width: 8),
        item.totalPrice != 0
            ? Text('RM ' + Format().currency(item.totalPrice, decimal: true))
            : Text('RM ' +
                Format().currency(double.parse(item.price), decimal: true)),
        SizedBox(width: 8),
      ],
    );
  }

  Row itemPriceService(ServicesCart item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Total'),
        SizedBox(width: 8),
        item.totalPrice != 0
            ? Text('RM ' + Format().currency(item.totalPrice, decimal: true))
            : Text('RM ' +
                Format().currency(double.parse(item.cost), decimal: true)),
        SizedBox(width: 8),
      ],
    );
  }

  Row itemPriceCourses(CoursesCart item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Total'),
        SizedBox(width: 8),
        item.totalPrice != 0
            ? Text('RM ' + Format().currency(item.totalPrice, decimal: true))
            : Text('RM ' +
                Format().currency(double.parse(item.fees), decimal: true)),
        SizedBox(width: 8),
      ],
    );
  }
}
