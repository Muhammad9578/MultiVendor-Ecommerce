import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mos_beauty/models/flash_sale_model.dart';
import 'package:mos_beauty/pages/home/widgets/header.dart';
import 'package:mos_beauty/pages/listCourses/listCourses.dart';
import 'package:mos_beauty/pages/listProduct/listProduct.dart';
import 'package:mos_beauty/pages/listService/listService.dart';
import 'package:mos_beauty/pages/mall/service/adsModel.dart';
import 'package:mos_beauty/pages/mall/service/flashSaleModel.dart';
import 'package:mos_beauty/pages/mall/service/mallModel.dart';
import 'package:mos_beauty/pages/mall/widget/flash_discount_item.dart';
import 'package:mos_beauty/pages/mall/widget/mos_icon.dart';
import 'package:mos_beauty/utils/flash_sale_view_model.dart';
import 'package:mos_beauty/utils/listCourses.dart';

class MallPage extends StatefulWidget {
  @override
  _MallPageState createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  final List<FlashSaleModel> _flashSaleViewModel =
      FlashSaleViewModel().getFlashSale();

  MallType _mallType;
  List<AdsData> adsList;
  FlashSaleData flashSaleList;
  bool loading = true;

  @override
  void initState() {
    var jsons = {};
    MallModel.mallDataPhp(jsons, context).then((value) {
      AdsModel.adsPhp(jsons).then((value2) {
        FlashSaleDataModel.flashSaleModelPhp(jsons).then((value3) {
          if (mounted) {
            setState(() {
              _mallType = value;
              adsList = value2;
              flashSaleList = value3;
              loading = false;
            });
          }
        });
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
            children: [
              HeaderBar(context: context),
              imageCarousel(),
              SizedBox(height: 10),
              typeIcon(context),
              SizedBox(height: 8),
              flashSaleList != null ? saleDisplay() : SizedBox(),
              SizedBox(height: 8),
              mostPopular(),
              SizedBox(height: 8),
              categoriesItem(),
            ],
          );
  }

  Container categoriesItem() {
    return Container(
      height: MediaQuery.of(context).size.height * 1 + 290,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Categories',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 34),
                Text(
                  'Product',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                _buildMoreButton('All Products', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ListProduct(
                        productFromListOrder: [],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _mallType == null
                  ? 0
                  : _mallType.categotyItem.categoryProduct.length,
              itemBuilder: (BuildContext context, i) {
                final item = _mallType.categotyItem.categoryProduct[i];
                return Row(
                  children: [
                    listItem(item.icon, item.name, item.productCategoryId),
                    SizedBox(width: 8)
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.grey, height: 1, thickness: 1),
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 34),
                Text(
                  'Services',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                _buildMoreButton('All Services', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ListService(
                        servicesFromListOrder: [],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.4 - 20,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _mallType == null
                  ? 0
                  : _mallType.categotyItem.categoryService.length,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.5),
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                var item = _mallType.categotyItem.categoryService[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListService(
                          servicesFromListOrder: [],
                          serviceCategoryId: item.serviceCategoryId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://mosbeauty.my/mos/pages/service-category/uploads/' +
                                  item.banner,
                          // placeholder: (context, url) =>
                          //     CircularProgressIndicator(),
                          // errorWidget: (context, url, error) =>
                          //     Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        //  Image.network(
                        //   'https://mosbeauty.my/mos/pages/service-category/uploads/' +
                        //       item.banner,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.grey, height: 1, thickness: 1),
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 34),
                Text(
                  'Courses',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                _buildMoreButton('All Courses', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ListCourses(
                        coursesFromListOrder: [],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.5 - 20,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _mallType == null
                  ? 0
                  : _mallType.categotyItem.categoryCourses.length,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.3),
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                var item = _mallType.categotyItem.categoryCourses[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListCourses(
                          coursesFromListOrder: [],
                          coursesCategoryId: item.coursesCategoryId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://mosbeauty.my/mos/pages/course-category/uploads/' +
                                  item.banner,
                          // placeholder: (context, url) =>
                          //     CircularProgressIndicator(),
                          // errorWidget: (context, url, error) =>
                          //     Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.grey, height: 1, thickness: 1),
          ),
        ],
      ),
    );
  }

  //! WIDGET
  InkWell listItem(image, title, productCategoryId) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ListProduct(
              productFromListOrder: [],
              productCategoryId: productCategoryId,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 110,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: CachedNetworkImage(
              imageUrl:
                  'https://mosbeauty.my/mos/pages/product-category/uploads/' +
                      image,
              // placeholder: (context, url) =>
              //     Center(child: CircularProgressIndicator()),
              // errorWidget: (context, url, error) => Icon(Icons.error),
              // imageBuilder: (context, imageProvider) => Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: imageProvider,
              //         fit: BoxFit.cover,
              //         colorFilter:
              //             ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
              //   ),
              // ),
              fit: BoxFit.cover,
            ),
            //  Image.network(
            //   'https://mosbeauty.my/mos/pages/product-category/uploads/' +
            //       image,
            //   fit: BoxFit.cover,
            // ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Container mostPopular() {
    return Container(
      height: 280,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ListCourses(
                            coursesFromListOrder: [],
                          ),
                        ),
                      );
                    },
                    child: displayView(
                        "assets/images/display1.jpg",
                        'Courses',
                        _mallType == null
                            ? ''
                            : '${_mallType.countItem.courses} courses'),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ListProduct(
                            productFromListOrder: [],
                          ),
                        ),
                      );
                    },
                    child: displayView(
                        "assets/images/display2.jpg",
                        'Product',
                        _mallType == null
                            ? ''
                            : '${_mallType.countItem.product} product'),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ListService(
                            servicesFromListOrder: [],
                          ),
                        ),
                      );
                    },
                    child: displayView(
                        "assets/images/display3.jpeg",
                        'Service',
                        _mallType == null
                            ? ''
                            : '${_mallType.countItem.service} service'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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

  Container typeIcon(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MosIcon(
            image: "assets/images/ICON-01.png",
            title: "Products",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ListProduct(
                    productFromListOrder: [],
                  ),
                ),
              );
            },
          ),
          MosIcon(
            image: "assets/images/ICON-02.png",
            title: "Services",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ListService(
                    servicesFromListOrder: [],
                  ),
                ),
              );
            },
          ),
          MosIcon(
            image: "assets/images/ICON-03.png",
            title: "Courses",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ListCourses(
                    coursesFromListOrder: [],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container displayView(asset, title, subtitle) {
    return Container(
      height: double.infinity,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
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

  FlatButton _buildMoreButton(title, Function onTap) => FlatButton(
        onPressed: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
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

  CountdownFormatted _buildCountDown() {
    var diff = flashSaleList.countDown;
    return CountdownFormatted(
      duration: flashSaleList.countDown == null
          ? Duration(hours: 2)
          : Duration(days: diff.day, hours: diff.hour, minutes: diff.minute),
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

  Container imageCarousel() {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: 150.0,
      width: double.infinity,
      child: CarouselSlider(
        items: adsList.map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              child: Image.network(
                'https://mosbeauty.my/mos/pages/ads/uploads/' + i.img,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          });
        }).toList(),
        options: CarouselOptions(
          height: height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          autoPlay: true,
        ),
      ),
    );
  }
}
