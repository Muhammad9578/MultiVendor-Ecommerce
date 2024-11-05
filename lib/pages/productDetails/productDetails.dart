import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/models/read_write.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/pages/coursesDetails/service/merchantModel.dart';
import 'package:mos_beauty/pages/listProduct/service/listProductModel.dart';
import 'package:mos_beauty/pages/mall/widget/rating_star.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/productDetails/service/productArray.dart';
import 'package:mos_beauty/pages/seeReviews/seeReview.dart';
import 'package:mos_beauty/pages/viewShop/viewshop_page.dart';
import 'package:mos_beauty/utils/format.dart';

class ProductDetails extends StatefulWidget {
  final Product itemProduct;
  final double totalDiscount;
  final double priceAfterDiscount;

  ProductDetails(this.itemProduct, this.totalDiscount, this.priceAfterDiscount);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  MerchantInfo merchantData;
  bool loading = true;

  String productToJson(Product data) => json.encode(data.toJson());
  List<ProductArray> productArrayFromJson(String str) =>
      List<ProductArray>.from(
          json.decode(str).map((x) => ProductArray.fromJson(x)));

  //* process add to cart make sure all in json.
  //*  store at storage file in local phone
  _processAddToCart() async {
    String fileName = 'cart';
    //ReadWrite.deleteFile(fileName);
    String dataStorage = await ReadWrite.read(fileName);
    print(dataStorage);
    if (dataStorage != null) {
      bool haveDuplicate;
      var checkProduct = productArrayFromJson(dataStorage);
      for (var u in checkProduct) {
        if (u.productId == widget.itemProduct.productId) {
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
        List listProduct = [];
        var product = productToJson(widget.itemProduct);
        listProduct.add(product);
        ReadWrite.write(listProduct.toString(), fileName);
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
            var storageProduct = json.encode(u);
            newList.add(storageProduct);
          }
          var product = productToJson(widget.itemProduct);
          newList.add(product);
          print(newList);
          ReadWrite.write(newList.toString(), fileName);
          _doneAddToCart();
        }
      }
    } else {
      List listProduct = [];
      var product = productToJson(widget.itemProduct);
      listProduct.add(product);
      ReadWrite.write(listProduct.toString(), fileName);
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
    MerchantModel.merchantInfoPhp(widget.itemProduct.merchantId).then((value) {
      setState(() {
        merchantData = value;
        widget.itemProduct.merchantName = merchantData.fullName;
        widget.itemProduct.merchantImage = merchantData.image;
        widget.itemProduct.totalDiscount = widget.totalDiscount;
        widget.itemProduct.priceAfterDiscount = widget.priceAfterDiscount;
        loading = false;
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
          widget.itemProduct.name,
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
                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://mosbeauty.my/mos/pages/product/uploads/' +
                                    widget.itemProduct.picture),
                            fit: BoxFit.cover),
                      ),
                    ),
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
          SizedBox(height: 10),
          Expanded(
            child: Row(
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
                      SizedBox(height: 10),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          merchantData.fullName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
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
                          Expanded(
                            child: Text(
                              merchantData.address,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
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
                      borderSide:
                          BorderSide(color: Colors.pink[300], width: 1.0),
                      color: Colors.pink[300],
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ViewShop(
                            merchantId: widget.itemProduct.merchantId,


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
          ),
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
      height: 370,
      padding: EdgeInsets.only(left: 10, top: 10, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.itemProduct.name.toUpperCase(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.itemProduct.shortDescription,
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
                        ? double.parse(widget.itemProduct.price)
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
                              '${Format().currency(double.parse(widget.itemProduct.price), decimal: true)}',
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
            'PRODUCT INFO',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Text(widget.itemProduct.description)
        ],
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
                SeeReview('product', widget.itemProduct.productId),
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
