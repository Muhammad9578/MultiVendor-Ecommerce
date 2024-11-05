import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/models/flash_sale_model.dart';
import 'package:mos_beauty/pages/activity/widgets/flash_sale_item.dart';
import 'package:mos_beauty/pages/home/widgets/header.dart';
import 'package:mos_beauty/pages/mall/service/adsModel.dart';
import 'package:mos_beauty/pages/mall/service/flashSaleModel.dart';
import 'package:mos_beauty/pages/mall/widget/flash_discount_item.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profile_detail.dart';
import 'package:mos_beauty/utils/flash_sale_view_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<FlashSaleModel> _flashSaleViewModel =
      FlashSaleViewModel().getFlashSale();

  List<AdsData> adsList;
  FlashSaleData flashSaleList;
  bool loading = true;
  String image1;
  String image2;
  String image3;
  @override
  void initState() {
    var jsons = {};
    AdsModel.adsPhp(jsons).then((value2) {
      FlashSaleDataModel.flashSaleModelPhp(jsons).then((value3) {
        if (mounted) {
          setState(() {
            adsList = value2;
            flashSaleList = value3;
            loading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: 800,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderBar(context: context),
              // Container(
              //   height: 500,
              //   width: double.infinity,
              //   margin: EdgeInsets.only(bottom: 20),
              //   color: Colors.white,
              //   child: Container(
              //     margin: EdgeInsets.all(20),
              //     height: double.infinity,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: NetworkImage(
              //             'https://mosbeauty.my/mos/pages/ads/uploads/' +
              //                 image1),
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),
              flashSaleList != null ? saleDisplay() : SizedBox(),
              SizedBox(
                height: 20,
              ),
              Column(
                children: adsList
                    .map(
                      (item) => Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 7, left: 7, top: 0),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, right: 20, left: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      // useOldImageOnUrlChange: false,
                                      imageUrl:
                                          'https://mosbeauty.my/mos/pages/ads/uploads/' +
                                              item.img,
                                      // errorWidget: (context, url, error) {
                                      //   return Icon(Icons.error);
                                      // },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, right: 20, left: 20),
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, right: 20, left: 20),
                                  child: Text(
                                    DateFormat("dd/mm/yyyy")
                                        .format(item.addDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // Row(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(left: 20, top: 20, right: 5),
              //       height: 300,
              //       width: 150,
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: NetworkImage(
              //               'https://mosbeauty.my/mos/pages/ads/uploads/' +
              //                   image2),
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     ),
              //     Container(
              //       margin: EdgeInsets.only(right: 20, top: 20, left: 5),
              //       height: 300,
              //       width: 200,
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: NetworkImage(
              //               'https://mosbeauty.my/mos/pages/ads/uploads/' +
              //                   image3),
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 50),
              Text(
                "That's all for now! ",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              SizedBox(height: 50),
            ],
          );
  }

  Container saleDisplay() {
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(
                  Icons.flash_on,
                  color: Colors.orange,
                  size: 24,
                ),
                Text(
                  'Flash Sale',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildCountDown(),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: flashSaleList.flashSale.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == flashSaleList.flashSale.length) {
                    return _buildMore();
                  }

                  final flashSale = flashSaleList.flashSale[index];
                  return FlashDiscountItem(flashSale);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildMore() {
    final Color color = Colors.deepOrange;
    return GestureDetector(
      onTap: () {
        print("click");
      },
      child: SizedBox(
        width: 150,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45.0,
              height: 45.0,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
                border: Border.all(
                  color: color,
                  width: 2.5,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ),
            Text(
              "View More",
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton _buildMoreButton() => FlatButton(
        onPressed: () {
          print("click");
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "All Products",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )
          ],
        ),
      );

  CountdownFormatted _buildCountDown() => CountdownFormatted(
        duration: Duration(hours: 2),
        builder: (BuildContext context, String remaining) {
          final showTime = (String text) => Container(
                width: 30,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
          List<String> time = remaining.split(':').toList();
          return Row(
            children: [
              showTime(time[0]),
              showTime(time[1]),
              showTime(time[2]),
            ],
          ); // 01:00:00
        },
      );
}
