import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/pages/listService/service/listServiceModel.dart';
import 'package:mos_beauty/pages/listService/service/serviceDiscountModel.dart';
import 'package:mos_beauty/pages/mall/widget/rating_star.dart';
import 'package:mos_beauty/pages/mall/widget/strike_line.dart';
import 'package:mos_beauty/pages/servicesDetails/serviceDetails.dart';
import 'package:mos_beauty/utils/format.dart';

class ListService extends StatefulWidget {
  final List servicesFromListOrder;
  final String serviceCategoryId;
  ListService({@required this.servicesFromListOrder, this.serviceCategoryId});
  @override
  _ListServiceState createState() => _ListServiceState();
}

class _ListServiceState extends State<ListService> {
  List<ServiceType> listService = [];
  List<DiscountService> discountService = [];
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
    if (widget.serviceCategoryId == null) {
      jsons["typeProduct"] = "service";
      jsons["isFromCategory"] = false;
    } else {
      jsons["typeProduct"] = "service";
      jsons["product_category_id"] = widget.serviceCategoryId;
      jsons["isFromCategory"] = true;
    }
    ListServiceModel.listProductPhp(jsons, context).then((value) {
      if (value.isNotEmpty) {
        ServiceDiscountModel.servicesDiscountPhp(jsons).then((value2) {
          if (this.mounted) {
            setState(() {
              listService = value;
              discountService = value2;
              loading = false;
              if (widget.servicesFromListOrder.isNotEmpty) {
                pushPageFromProductOrder(discountService);
              } else {
                loading = false;
              }
            });
          }
        });
      } else {
        if (this.mounted) {
          setState(() {
            listService = value;
            if (widget.servicesFromListOrder.isNotEmpty) {
              pushPageFromProductOrder(null);
            } else {
              loading = false;
            }
            loading = false;
          });
        }
      }
    });
    super.initState();
  }

  pushPageFromProductOrder(getDataDiscount) {
    if (getDataDiscount != null) {
      listService.forEach((item) {
        if (item.serviceId == widget.servicesFromListOrder[0]) {
          double discount = 0;
          for (var u in discountService) {
            if (u.itemId == widget.servicesFromListOrder[0]) {
              discount = double.parse(u.discountOff);
              break;
            }
          }
          double totalDiscount = double.parse(item.cost) -
              (double.parse(item.cost) * discount / 100);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ServiceDetails(item, discount, totalDiscount),
            ),
          ).then((value) {
            setState(() {
              loading = false;
            });
          });
        }
      });
    } else {
      listService.forEach((item) {
        if (item.serviceId == widget.servicesFromListOrder[0]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ServiceDetails(item, 0, 0),
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
            : listService.isEmpty
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
                    itemCount: listService.length,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.2),
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = listService[index];
                      bool haveTrue = false;
                      double discount = 0;
                      for (var u in discountService) {
                        if (u.itemId == item.serviceId) {
                          discount = double.parse(u.discountOff);
                          haveTrue = true;
                          break;
                        } else {
                          haveTrue = false;
                        }
                      }
                      if (haveTrue) {
                        //* this is for discount UI
                        double totalDiscount = double.parse(item.cost) -
                            (double.parse(item.cost) * discount / 100);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ServiceDetails(
                                        item, discount, totalDiscount),
                              ),
                            );
                          },
                          child: GridTile(
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 0.5),
                                ),
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
                                            'https://mosbeauty.my/mos/pages/service/uploads/' +
                                                item.image,
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
                                        )
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
                                              item.name,
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
                                              item.description,
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
                                                          '${Format().currency(double.parse(item.cost), decimal: true)}',
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
                                    ServiceDetails(item, 0, 0),
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
                                        'https://mosbeauty.my/mos/pages/service/uploads/' +
                                            item.image,
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
                                              item.name,
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
                                              item.description,
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
                                                      double.parse(item.cost),
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
