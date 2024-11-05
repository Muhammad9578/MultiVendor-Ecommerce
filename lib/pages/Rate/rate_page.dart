import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/Rate/service/rateModel.dart';
import 'package:mos_beauty/pages/listToDelivery/service/toDeliveryModel.dart';
import 'package:mos_beauty/pages/return/service/returnModel.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatePage extends StatefulWidget {
  final ListItem childItem;
  RatePage({this.childItem});
  @override
  _RatePageState createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  ListItem childItem;
  double rating = 0.0;
  final feedback = TextEditingController();

  @override
  void initState() {
    childItem = widget.childItem;
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
          'RATE FEEDBACK',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: ListView(
              children: [
                itemInfo(),
                Divider(
                  height: 1,
                  color: Colors.black,
                ),
                Container(
                  color: Colors.white,
                  height: 300,
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  child: itemFeedback(),
                )
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomWidget())
        ],
      ),
    );
  }

  sendToApi() {
    var jsons = {};
    jsons["item_type"] = childItem.itemType == Type.PRODUCT
        ? "product"
        : childItem.itemType == Type.SERVICE
            ? "service"
            : "courses";
    jsons["item_id"] = childItem.itemId;
    jsons["feedback"] = feedback.text;
    jsons["rating"] = rating.toString();
    jsons["purchases_id"] = childItem.purchasesId;
    jsons["purchases_item_id"] = childItem.purchasesItemId;
    print(jsons);
    RateModel.rateModel(jsons, context);
  }

  InkWell bottomWidget() {
    return InkWell(
      onTap: () => sendToApi(),
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
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Submit",
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
          ],
        ),
      ),
    );
  }

  Container itemFeedback() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            'Feedback',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: TextField(
                controller: feedback,
                maxLines: 8,
                decoration: InputDecoration.collapsed(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(3.0),
                      borderSide: new BorderSide(),
                    ),
                    hintText: ""),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(height: 8),
          Text(
            'Rating Star',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SmoothStarRating(
              rating: rating,
              isReadOnly: false,
              size: 30,
              color: Colors.orange,
              borderColor: Colors.orangeAccent,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              onRated: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Container itemInfo() {
    return Container(
      color: Colors.white,
      height: 150,
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
                    margin: EdgeInsets.only(left: 5, right: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                            childItem.merchantImage),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                childItem.merchantName,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 20.0,
                              height: 40.0,
                              child: RaisedButton(
                                color: Colors.greenAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ViewShop(
                                      merchantId: childItem.merchantId,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Visit Shop",
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              'RM ' +
                                  Format().currency(
                                      double.parse(childItem.priceDiscount),
                                      decimal: true),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    Text(
                                      'Type',
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 110,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.childItem.quantity),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          imageUrl: 'https://mosbeauty.my/mos/pages/service/uploads/' +
              childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      case Type.PRODUCT:
        return CachedNetworkImage(
          imageUrl: 'https://mosbeauty.my/mos/pages/product/uploads/' +
              childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      case Type.COURSES:
        return CachedNetworkImage(
          imageUrl: 'https://mosbeauty.my/mos/pages/courses/uploads/' +
              childItem.itemImage,
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
        break;
      default:
    }
  }
}
