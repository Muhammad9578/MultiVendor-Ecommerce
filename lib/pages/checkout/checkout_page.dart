import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/models/read_write.dart';
import 'package:mos_beauty/pages/checkout/services/checkoutModel.dart';
import 'package:mos_beauty/pages/coursesDetails/service/coursesCart.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/productDetails/service/productArray.dart';
import 'package:mos_beauty/pages/servicesDetails/service/sevicesCart.dart';
import 'package:mos_beauty/utils/format.dart';

class CheckOutPage extends StatefulWidget {
  final List<ProductArray> selectedItem;
  final List<CoursesCart> selectedCourses;
  final List<ServicesCart> selectedServices;
  final double grandTotal;

  CheckOutPage(
      {this.selectedItem,
      this.selectedCourses,
      this.selectedServices,
      this.grandTotal});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  int totalList = 0;
  CheckoutData checkoutInfo;
  bool loading = true;
  bool _switchValue = false;
  double placeholder = 0;
  double pointsToBeEarned = 0;
  List<ProductArray> productArrayFromJson(String str) =>
      List<ProductArray>.from(
          json.decode(str).map((x) => ProductArray.fromJson(x)));
  String productArrayToJson(List<ProductArray> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    var jsons = {};
    jsons['grand_total'] = widget.grandTotal.toString();
    CheckoutModel.checkoutPhp(jsons).then((value) {
      setState(() {
        checkoutInfo = value;
        totalList = widget.selectedItem.length +
            widget.selectedCourses.length +
            widget.selectedServices.length;
        calculationPlaceholder();
        loading = false;
      });
    });
    super.initState();
  }

  calculationPlaceholder() {
    if (_switchValue) {
      placeholder = widget.grandTotal - checkoutInfo.mosPointToRedeemedRm;
      pointsToBeEarned = placeholder / 100;
    } else {
      placeholder = widget.grandTotal - 0.00;
      pointsToBeEarned = placeholder / 100;
    }
  }

  void _deleteProcessProduct(ProductArray item) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 70),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      infoUser(),
                      SizedBox(height: 8),
                      producItem(),
                      coursesItem(),
                      servicesItem(),
                      SizedBox(height: 20),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                  child:
                                      Text('Order Total ($totalList Item) : ')),
                              Text('RM ' +
                                  Format().currency(widget.grandTotal,
                                      decimal: true)),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                child: Text('Mos Point Balance : '),
                              ),
                              Text(
                                checkoutInfo.mosPointBalance.toString() +
                                    " Mos Point",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 17,
                              ),
                              SizedBox(width: 8),
                              Text('Mos Point Redeem : '),
                              Expanded(
                                child: Text(
                                    "[ - RM " +
                                        checkoutInfo.mosPointToRedeemedRm
                                            .toString() +
                                        " ]",
                                    style: TextStyle(
                                        color: _switchValue
                                            ? Colors.black
                                            : Colors.grey)),
                              ),
                              CupertinoSwitch(
                                value: _switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    _switchValue = value;
                                    calculationPlaceholder();
                                  });
                                },
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Icon(
                                FontAwesomeIcons.coins,
                                color: Colors.orange,
                                size: 17,
                              ),
                              SizedBox(width: 8),
                              Expanded(child: Text('Mos Credit Balance : ')),
                              Text('RM ' +
                                  Format().currency(
                                      checkoutInfo.mosCreditBalance,
                                      decimal: true)),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 130,
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('Merchant Subtotal :')),
                                  Text('RM ' +
                                      Format().currency(widget.grandTotal,
                                          decimal: true)),
                                  SizedBox(width: 12),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('Voucher Discount :')),
                                  Text('- RM ' +
                                      Format().currency(0, decimal: true)),
                                  SizedBox(width: 12),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text('Mos Points Redeemed :')),
                                  !_switchValue
                                      ? Text('- RM ' +
                                          Format().currency(0, decimal: true))
                                      : Text('- RM ' +
                                          Format().currency(
                                              checkoutInfo.mosPointToRedeemedRm,
                                              decimal: true)),
                                  SizedBox(width: 12),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('Total Payment :')),
                                  Text(
                                      'RM ' +
                                          Format().currency(placeholder,
                                              decimal: true),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 12),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Expanded(
                                  child: Text('Mos Points to be earned : ')),
                              Text(
                                pointsToBeEarned
                                        .toString()
                                        .split('.')[1]
                                        .substring(0, 1) +
                                    " Mos Point",
                                style: TextStyle(color: Colors.orange),
                              ),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Align(alignment: Alignment.bottomCenter, child: bottomWidget())
              ],
            ),
    );
  }

  Column servicesItem() {
    return Column(
      children: widget.selectedServices
          .map(
            (item) => Container(
              height: 200,
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
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
                                              ],
                                            ),
                                          ),
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
                                              SizedBox(width: 8),
                                              Text(
                                                  '${item.quantityItem.toString()} Qty'),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Divider(
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 5),
                                          itemPriceService(item),
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

  Column coursesItem() {
    return Column(
      children: widget.selectedCourses
          .map(
            (item) => Container(
              height: 200,
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
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
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item.title}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                  '${item.quantityItem.toString()} Qty'),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Divider(
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 5),
                                          itemPriceCourses(item),
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

  Column producItem() {
    return Column(
      children: widget.selectedItem
          .map(
            (item) => Container(
              height: 200,
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
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
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
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
                                              ],
                                            ),
                                          ),
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
                                              SizedBox(width: 8),
                                              Text(
                                                  '${item.quantityItem.toString()} Qty'),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Divider(
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          SizedBox(height: 5),
                                          itemPrice(item),
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

  Container infoUser() {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      width: double.infinity,
      child: Card(
        elevation: 2,
        shadowColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blueGrey,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Delivery Address',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'John Due',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'No 6, Jalan 16/2B Taman Cheras Jaya',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row itemPriceCourses(CoursesCart item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* check kosong for tahu price itu ada discount atau tidak.
            item.priceAfterDiscount == 0
                ? item.totalPrice != 0
                    ? Text('RM ' +
                        Format().currency(item.totalPrice, decimal: true))
                    : Text('RM ' +
                        Format()
                            .currency(double.parse(item.fees), decimal: true))
                : Text(
                    'RM ' +
                        Format().currency(
                            item.priceAfterDiscount == 0
                                ? item.totalPrice
                                : item.priceAfterDiscount,
                            decimal: true),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            item.priceAfterDiscount == 0
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
                                '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.fees), decimal: true)}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Row itemPriceService(ServicesCart item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* check kosong for tahu price itu ada discount atau tidak.
            item.priceAfterDiscount == 0
                ? item.totalPrice != 0
                    ? Text('RM ' +
                        Format().currency(item.totalPrice, decimal: true))
                    : Text('RM ' +
                        Format()
                            .currency(double.parse(item.cost), decimal: true))
                : Text(
                    'RM ' +
                        Format().currency(
                            item.priceAfterDiscount == 0
                                ? item.totalPrice
                                : item.priceAfterDiscount,
                            decimal: true),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            item.priceAfterDiscount == 0
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
                                '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.cost), decimal: true)}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Row itemPrice(ProductArray item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* check kosong for tahu price itu ada discount atau tidak.
            item.priceAfterDiscount == 0
                ? item.totalPrice != 0
                    ? Text('RM ' +
                        Format().currency(item.totalPrice, decimal: true))
                    : Text('RM ' +
                        Format()
                            .currency(double.parse(item.price), decimal: true))
                : Text(
                    'RM ' +
                        Format().currency(
                            item.priceAfterDiscount == 0
                                ? item.totalPrice
                                : item.priceAfterDiscount,
                            decimal: true),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            item.priceAfterDiscount == 0
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
                                '${Format().currency(item.totalPrice != 0 ? item.totalPrice : double.parse(item.price), decimal: true)}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  sendToAPI() {
    List listCart = [];
    List<ProductArray> product = [];
    List<CoursesCart> courses = [];
    List<ServicesCart> services = [];

    ReadWrite.read('cart').then((value) {
      if (value != null) {
        print(value);
        final productCart = productArrayFromJson(value);
        if (this.mounted) {
          setState(() {
            product = productCart;
          });
        }
      }
    });
    ReadWrite.read('cartCourses').then((value) {
      if (value != null) {
        final coursesCart = coursesCartFromJson(value);
        if (this.mounted) {
          setState(() {
            courses = coursesCart;
          });
        }
      }
    });
    ReadWrite.read('cartServices').then((value) {
      if (value != null) {
        final servicesCart = servicesCartFromJson(value);
        if (this.mounted) {
          setState(() {
            services = servicesCart;
          });
        }
      }
    });
    for (var u in widget.selectedItem) {
      if (mounted) {
        setState(() {
          product.removeWhere((element) => element.productId == u.productId);
        });
      }
      var jsonProduct = {};
      jsonProduct["item_id"] = u.productId;
      jsonProduct["item_type"] = "product";
      jsonProduct["quantity"] = u.quantityItem;
      jsonProduct["influencer_id"] = 0;
      listCart.add(jsonProduct);
    }
    for (var u in widget.selectedCourses) {
      if (mounted) {
        setState(() {
          courses.removeWhere((element) => element.coursesId == u.coursesId);
        });
      }
      var jsonProduct = {};
      jsonProduct["item_id"] = u.coursesId;
      jsonProduct["item_type"] = "courses";
      jsonProduct["quantity"] = u.quantityItem;
      jsonProduct["influencer_id"] = 0;
      listCart.add(jsonProduct);
    }
    for (var u in widget.selectedServices) {
      if (mounted) {
        setState(() {
          services.removeWhere((element) => element.serviceId == u.serviceId);
        });
      }
      var jsonProduct = {};
      jsonProduct["item_id"] = u.serviceId;
      jsonProduct["item_type"] = "service";
      jsonProduct["quantity"] = u.quantityItem;
      jsonProduct["influencer_id"] = 0;
      listCart.add(jsonProduct);
    }
    var jsons = {};
    jsons['merchant_subtotal'] = widget.grandTotal;
    jsons['shop_voucher'] = '';
    jsons['mos_point_redeem'] =
        _switchValue ? checkoutInfo.mosPointToRedeemedRm : 0;
    jsons['grand_total'] = widget.grandTotal;
    jsons['total_payment'] = placeholder;
    jsons['mos_point_earned'] =
        pointsToBeEarned.toString().split('.')[1].substring(0, 1);
    jsons['listCart'] = listCart;
    
    //* proses remove add to cart
    final productToJson = productArrayToJson(product);
    ReadWrite.write(productToJson, 'cart');
    final coursesToJson = coursesCartToJson(courses);
    ReadWrite.write(coursesToJson, 'cartCourses');
    final servicesToJson = servicesCartToJson(services);
    ReadWrite.write(servicesToJson, 'cartServices');

    //* this is send to api
    CheckoutModel.placeholder(jsons, context);
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () => sendToAPI(),
      child: Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[2],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.8,
              padding: EdgeInsets.only(right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Total Payment',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'RM ' + Format().currency(placeholder, decimal: true),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
