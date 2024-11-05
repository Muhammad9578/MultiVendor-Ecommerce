import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/models/read_write.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/pages/coursesDetails/service/merchantModel.dart';
import 'package:mos_beauty/pages/listService/service/listServiceModel.dart';
import 'package:mos_beauty/pages/mall/widget/rating_star.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/servicesDetails/service/serviceDetailsModel.dart';
import 'package:mos_beauty/pages/servicesDetails/service/sevicesCart.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceType itemService;
  final double totalDiscount;
  final double priceAfterDiscount;

  ServiceDetails(this.itemService, this.totalDiscount, this.priceAfterDiscount);
  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  List<ServicesArray> servicesList = [];
  int onSelected = 0;
  bool loading = true;
  List<ServicesArray> servicesSelected = [];
  MerchantInfo merchantData;

  List<ServicesCart> servicesCartFromJson(String str) =>
      List<ServicesCart>.from(
          json.decode(str).map((x) => ServicesCart.fromJson(x)));

  @override
  void initState() {
    var jsons = {};
    jsons['servicesId'] = widget.itemService.serviceId;
    ServiceDetailsModel().servicesDetailsPhp(jsons).then((value) {
      MerchantModel.merchantInfoPhp(widget.itemService.merchantId)
          .then((value2) {
        setState(() {
          servicesList = value;
          merchantData = value2;
          widget.itemService.merchantName = merchantData.fullName;
          widget.itemService.merchantImage = merchantData.image;
          widget.itemService.totalDiscount = widget.totalDiscount.toString();
          widget.itemService.priceAfterDiscount =
              widget.priceAfterDiscount.toString();
          loading = false;
        });
      });
    });
    super.initState();
  }

  String serviceTypeToJson(ServiceType data) => json.encode(data.toJson());
  //* process add to cart make sure all in json.
  //*  store at storage file in local phone
  _processAddToCart() async {
    print(servicesSelected);
    if (servicesSelected.isNotEmpty) {
      widget.itemService.timeSession = servicesSelected;
      String fileName = 'cartServices';
      // ReadWrite.deleteFile(fileName);
      String dataStorage = await ReadWrite.read(fileName);
      if (dataStorage != null) {
        bool haveDuplicate;
        var checkServicesDuplicate = servicesCartFromJson(dataStorage);
        for (var u in checkServicesDuplicate) {
          if (u.serviceId == widget.itemService.serviceId) {
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
          List listServices = [];
          var services = serviceTypeToJson(widget.itemService);
          listServices.add(services);
          ReadWrite.write(listServices.toString(), fileName);
          _doneAddToCart();
        } else {
          if (haveDuplicate) {
            //TODO implement interact to user item was already add to cart
            print('have duplicate here');
            _alreadyAddToCart();
          } else {
            final jsonDecode = json.decode(dataStorage);
            List newList = [];
            for (var u in jsonDecode) {
              var storageServices = json.encode(u);
              newList.add(storageServices);
            }
            var services = serviceTypeToJson(widget.itemService);
            newList.add(services);
            ReadWrite.write(newList.toString(), fileName);
            _doneAddToCart();
          }
        }
      } else {
        List listServices = [];
        var services = serviceTypeToJson(widget.itemService);
        listServices.add(services);
        ReadWrite.write(listServices.toString(), fileName);
        _doneAddToCart();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please select time table first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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

  String formatTimeOfDay(TimeOfDay tod, String mode) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format =
        (mode == '24Hour') ? DateFormat.Hm() : DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
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
          widget.itemService.name,
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
      body: Stack(
        children: [
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    imageView(),
                    Stack(
                      children: [
                        detailsItemView(),
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

  Container detailsItemView() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      height: 300,
      padding: EdgeInsets.only(left: 10, top: 10, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.itemService.name.toUpperCase(),
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
            widget.itemService.description,
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
                        ? double.parse(widget.itemService.cost)
                        : widget.priceAfterDiscount,
                    decimal: true),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.pink[300],
              fontSize: 22.0,
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
                              '${Format().currency(double.parse(widget.itemService.cost), decimal: true)}',
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
          Text(
            'OPEN DAY (YOU CAN SELECT ${widget.itemService.sessionPackage} ONLY)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                itemCount: servicesList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, i) {
                  final item = servicesList[i];
                  return InkWell(
                    onTap: () {
                      if (servicesSelected.length <
                          int.parse(widget.itemService.sessionPackage)) {
                        if (item.whyMeSelected == 0) {
                          servicesSelected.add(item);
                          setState(() {
                            item.whyMeSelected = 1;
                          });
                        } else {
                          servicesSelected.removeWhere((element) =>
                              element.serviceSessionId ==
                              item.serviceSessionId);
                          setState(() {
                            item.whyMeSelected = 0;
                          });
                        }
                      } else {
                        if (item.whyMeSelected == 1) {
                          servicesSelected.removeWhere((element) =>
                              element.serviceSessionId ==
                              item.serviceSessionId);
                          setState(() {
                            item.whyMeSelected = 0;
                          });
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: double.infinity,
                      width: 120,
                      decoration: BoxDecoration(
                        color: item.whyMeSelected == 1
                            ? Colors.pink[300]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: item.whyMeSelected == 1
                              ? Colors.white
                              : Color(0xff000000),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            item.day,
                            style: TextStyle(
                              color: item.whyMeSelected == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            formatTimeOfDay(
                                TimeOfDay(
                                    hour: int.parse(item.time.split(":")[0]),
                                    minute: int.parse(item.time.split(":")[1])),
                                '12Hour'),
                            style: TextStyle(
                              color: item.whyMeSelected == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container seeReview() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 3, right: 8),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'SEE REVIEWS',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          StarRating(
            rating: 4.5,
            color: Colors.red,
            size: 18,
          ),
          Text(
            '(2567)',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Container imageView() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://mosbeauty.my/mos/pages/service/uploads/' +
                    widget.itemService.image),
            fit: BoxFit.cover),
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
                          merchantId: widget.itemService.merchantId,
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
