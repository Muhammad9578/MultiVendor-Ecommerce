import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/pages/listCourses/listCourses.dart';
import 'package:mos_beauty/pages/listProduct/listProduct.dart';
import 'package:mos_beauty/pages/listService/listService.dart';
import 'package:mos_beauty/pages/listToDelivery/service/toDeliveryModel.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';

class ListToReturn extends StatefulWidget {
  @override
  _ListToReturnState createState() => _ListToReturnState();
}

class _ListToReturnState extends State<ListToReturn> {
  bool loading = true;
  List<PurchasesData> listDelivery = [];

  @override
  void initState() {
    var jsons = {};
    jsons['type'] = 'return';
    PurchasesCategory.purchasesCategoryPhp(jsons).then((value) {
      if (this.mounted) {
        setState(() {
          listDelivery = value;
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listDelivery.isEmpty
            ? Center(
                child: Text('No Order Yet',
                    style: TextStyle(color: Colors.blueGrey, letterSpacing: 2)))
            : ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: listDelivery.map((PurchasesData item) {
                      textShippingStatus() {
                        switch (item.shippingStatus) {
                          case ShippingStatus.CANCELLED:
                            return Text('Cancelled',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1));
                            break;
                          case ShippingStatus.COMPLETED:
                            return Text('Completed',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1));
                            break;
                          case ShippingStatus.RETURN:
                            String status = "";
                            if (item.status == "5") {
                              status = 'PENDING';
                            } else if (item.status == "6") {
                              status = 'APPROVE';
                            } else {
                              status = 'REJECT';
                            }
                            return Text('Return' + " (  $status )",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1));
                            break;
                          case ShippingStatus.TO_DELIVERY:
                            return Text('To Delivery',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1));
                            break;
                          case ShippingStatus.TO_RECEIVED:
                            return Text('To received',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1));
                            break;
                          default:
                        }
                      }

                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 110,
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('ORDER NO ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            letterSpacing: 1)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(item.invoiceNo.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            letterSpacing: 1)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Shipping Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            letterSpacing: 1)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    textShippingStatus()
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  'Placed on ' +
                                      DateFormat('EEEE, d MMM, yyyy')
                                          .format(item.datetime),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      letterSpacing: 1),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'ITEM ',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item.listItem.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          letterSpacing: 2),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 25,
                                      ),
                                    ),
                                    Text(
                                      'TOTAL ',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "RM " +
                                          Format().currency(item.totalPrice,
                                              decimal: true),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          letterSpacing: 2),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: item.listItem.map((ListItem childItem) {
                              textType() {
                                switch (childItem.itemType) {
                                  case Type.SERVICE:
                                    return Text('Service');
                                    break;
                                  case Type.PRODUCT:
                                    return Text('Product');
                                    break;
                                  case Type.COURSES:
                                    return Text('Courses');
                                    break;
                                  default:
                                }
                              }

                              checkItemTypeImage() {
                                switch (childItem.itemType) {
                                  case Type.SERVICE:
                                    return CachedNetworkImage(
                                      imageUrl:
                                          'https://mosbeauty.my/mos/pages/service/uploads/' +
                                              childItem.itemImage,
                                      // errorWidget: (context, url, error) =>
                                      //     Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    );
                                    break;
                                  case Type.PRODUCT:
                                    return CachedNetworkImage(
                                      imageUrl:
                                          'https://mosbeauty.my/mos/pages/product/uploads/' +
                                              childItem.itemImage,
                                      // errorWidget: (context, url, error) =>
                                      //     Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    );
                                    break;
                                  case Type.COURSES:
                                    return CachedNetworkImage(
                                      imageUrl:
                                          'https://mosbeauty.my/mos/pages/courses/uploads/' +
                                              childItem.itemImage,
                                      // errorWidget: (context, url, error) =>
                                      //     Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    );
                                    break;
                                  default:
                                }
                              }

                              buttonTypeShipping() {
                                switch (item.shippingStatus) {
                                  case ShippingStatus.CANCELLED:
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        button('BUY AGAIN', () {}),
                                        SizedBox(width: 5),
                                        button('SEE DETAILS', () {}),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                    break;
                                  case ShippingStatus.COMPLETED:
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        button('RATE', () {}),
                                        SizedBox(width: 5),
                                        button('SEE DETAILS', () {}),
                                        SizedBox(width: 5),
                                        button('BUY AGAIN', () {}),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                    break;
                                  case ShippingStatus.RETURN:
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        button('Buy Again', () {}),
                                        SizedBox(width: 5),
                                        button(
                                            'See Details',
                                            () => seeDetails(
                                                childItem.itemType, childItem)),
                                        SizedBox(width: 10),
                                        // button('REJECT', () {}),
                                        // SizedBox(width: 5),
                                        // button('PENDING', () {}),
                                        // SizedBox(width: 5),
                                        // button('DISBUTE', () {}),
                                        // SizedBox(width: 10),
                                      ],
                                    );
                                    break;
                                  case ShippingStatus.TO_DELIVERY:
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        button('CANCEL', () {}),
                                        SizedBox(width: 5),
                                        button('SEE DETAILS', () {}),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                    break;
                                  case ShippingStatus.TO_RECEIVED:
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        button('CANCEL', () {}),
                                        SizedBox(width: 5),
                                        button('SEE DETAILS', () {}),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                    break;
                                  default:
                                }
                              }

                              return Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 3),
                                height: 220,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(10),
                                              height: double.infinity,
                                              width: 110,
                                              child: checkItemTypeImage()),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 10, top: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                                                      childItem
                                                                          .merchantImage),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          childItem
                                                              .merchantName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                      ButtonTheme(
                                                        minWidth: 20.0,
                                                        height: 40.0,
                                                        child: RaisedButton(
                                                          color: Colors
                                                              .greenAccent,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3.0),
                                                            side: BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ViewShop(
                                                                merchantId:
                                                                    childItem
                                                                        .merchantId,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Visit Shop",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          childItem.itemName,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'RM ' +
                                                            Format().currency(
                                                                double.parse(
                                                                    childItem
                                                                        .priceDiscount),
                                                                decimal: true),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 80,
                                                          height:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Quantity',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey),
                                                              ),
                                                              Text(
                                                                'Type',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 110,
                                                          height:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(childItem
                                                                  .quantity),
                                                              textType(),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: 60,
                                        width: double.infinity,
                                        child: buttonTypeShipping()),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  // SizedBox(height: 15),
                  // buildContainer(),
                  // SizedBox(height: 15),
                  // buildContainer(),
                  // SizedBox(height: 15),
                  // buildContainer(),
                  // SizedBox(height: 15),
                  // buildContainer(),
                ],
              );
  }

  seeDetails(itemType, ListItem childItem) {
    List item = [childItem.itemId];
    if (itemType == Type.COURSES) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ListCourses(
            coursesFromListOrder: item,
          ),
        ),
      );
    } else if (itemType == Type.PRODUCT) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ListProduct(
            productFromListOrder: item,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ListService(
            servicesFromListOrder: item,
          ),
        ),
      );
    }
  }

  ButtonTheme button(String title, Function onTap) {
    return ButtonTheme(
      minWidth: 80.0,
      height: 40.0,
      buttonColor: Color.fromRGBO(234, 135, 137, 1.0),
      child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontFamily: 'MuseoSans',
            ),
          ),
          onPressed: onTap),
    );
  }

  Container buildContainer() {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 5),
            Container(
              height: 35,
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '3-7 Day after service done customer can review & comment. Review lower than 3 star will be hide',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: 80,
                    child: FlatButton(
                      color: Colors.green,
                      child: Text(
                        'DONE',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
            SizedBox(height: 3),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Container(
                    height: double.infinity,
                    margin: EdgeInsets.all(5),
                    width: 90,
                    child: Placeholder(),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  child: Placeholder(),
                                ),
                                SizedBox(width: 8),
                                Text('Manuqure'),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ButtonTheme(
                                    height: 25.0,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () {},
                                      child: Text(
                                        "CHAT",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: ButtonTheme(
                                    height: 25.0,
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () {},
                                      child: Text(
                                        "VISIT SHOP",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                'Spa Manicure',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Spacer(),
                              Text('RM90.00')
                            ],
                          ),
                          SizedBox(height: 3),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Text('1x SESSION'),
                              Spacer(),
                              Text('TOTAL'),
                              SizedBox(width: 8),
                              Text('RM90.00')
                            ],
                          ),
                          Row(
                            children: [
                              Text('5-10-2020'),
                              SizedBox(width: 8),
                              Expanded(
                                child: ButtonTheme(
                                  minWidth: 200.0,
                                  height: 25.0,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () {},
                                    child: Text(
                                      "BUY AGAIN",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ButtonTheme(
                                  height: 25.0,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () {},
                                    child: Text(
                                      "SEE DETAILS",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
