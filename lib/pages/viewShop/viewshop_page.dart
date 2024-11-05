import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:mos_beauty/pages/viewShop/service/viewshopModel.dart';
import 'package:mos_beauty/pages/chat/chatScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mos_beauty/models/FollowModel.dart';

class ViewShop extends StatefulWidget {
  final String merchantId;

  ViewShop({@required this.merchantId,});
  @override
  _ViewShopState createState() => _ViewShopState();
}

class _ViewShopState extends State<ViewShop> {


  String currentUserName;
  String userId;
  String currentImage;
  MerchantDataInfo merchantDataInfo;
  bool loading = true;
  bool following=false;
  @override
  void initState() {
    var jsons = {};
    jsons["merchantId"] = widget.merchantId;
    ViewShopModel.merchantPage(jsons).then((value) {
      if (mounted) {
        setState(() {
          merchantDataInfo = value;
          // print(merchantDataInfo.image);
          loading = false;
        });
      }

    }).whenComplete(() => getCurrentId());

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
          'View Shop',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ListView(
                children: [
                  merchantInfo(),
                  productList(),
                  coursesList(),
                  servicesList(),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );

  }
  getCurrentId() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() {
      userId=prefs.getString('userId');
      currentUserName=prefs.getString('userName');

      currentImage=prefs.getString("image");
    });
    var jsons = {};
    jsons["user_id"] = widget.merchantId;
    jsons["followby"] = userId;
    FollowModel.followPhp(jsons, context).then((value) {


      if(value=='"Already Followed"'){
        setState(() {
          following = true;
        });
      }else{
        setState(() {
          following = false;
        });
      }

    });
}

  Container servicesList() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 15),
      height: 270,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Services',
            style: TextStyle(
                fontWeight: FontWeight.w400, letterSpacing: 2, fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: merchantDataInfo.serviceList.length,
                itemBuilder: (BuildContext context, i) {
                  final item = merchantDataInfo.serviceList[i];
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border:
                              Border.all(color: Colors.blueGrey, width: 1.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://mosbeauty.my/mos/pages/service/uploads/' +
                                            item.image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Text(
                                item.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Container coursesList() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 15),
      height: 270,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Courses',
            style: TextStyle(
                fontWeight: FontWeight.w400, letterSpacing: 2, fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: merchantDataInfo.coursesList.length,
                itemBuilder: (BuildContext context, i) {
                  final item = merchantDataInfo.coursesList[i];
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border:
                              Border.all(color: Colors.blueGrey, width: 1.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://mosbeauty.my/mos/pages/courses/uploads/' +
                                            item.icon),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Text(
                                item.title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Container productList() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 15),
      height: 270,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Product',
            style: TextStyle(
                fontWeight: FontWeight.w400, letterSpacing: 2, fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: merchantDataInfo.productList.length,
                itemBuilder: (BuildContext context, i) {
                  final item = merchantDataInfo.productList[i];
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border:
                              Border.all(color: Colors.blueGrey, width: 1.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://mosbeauty.my/mos/pages/product/uploads/' +
                                            item.picture),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Text(
                                item.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Container merchantInfo() {
    // print("value of following ${merchantDataInfo.userName} ${merchantDataInfo.image} ${merchantDataInfo.image} ${merchantDataInfo.email}");
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
          // SizedBox(height: 10),
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
                        image: merchantDataInfo.image == null
                            ? AssetImage('assets/images/avatar1.png')
                            : CachedNetworkImageProvider(
                                'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                    merchantDataInfo.image),
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
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            merchantDataInfo.fullName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                            ),
                          ),
                          OutlinedButton.icon(
                            icon: Icon(MdiIcons.comment,color: Colors.blue,),
                            label: Text("Chat",style: TextStyle(color: Colors.blue),),
                            onPressed: () {
                              if (userId != null) {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (_) =>
                                        ChatScreen(serviceProviderId: widget
                                            .merchantId,
                                            userName: merchantDataInfo.fullName,
                                            avatarUrl: 'https://mosbeauty.my/mos/pages/merchant/pic/' +
                                                '${merchantDataInfo.image}',
                                            currentUserId: userId,
                                            currentUserName: currentUserName,
                                            currentUserImage: currentImage)));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            size: 15,
                            color: Colors.grey,
                          ),
                          Text(
                            merchantDataInfo.email,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton.icon(
                        icon: Icon(Icons.favorite_border,color: Colors.blue,),
                        label: Text(following==true?"Following":"Follow",style: TextStyle(color: Colors.blue),),
                        onPressed: () {

                          var jsons = {};
                          jsons["user_id"] = merchantDataInfo.userId;
                          jsons["followby"] = userId;
                          FollowModel.followPhp(jsons, context).then((value) {
                            print('value at viewshop is $value');
                            setState(() {
                              following = true;
                            });

                            // print(" value at login $value");
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(width: 2.0, color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    merchantDataInfo.product,
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
                    merchantDataInfo.service,
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
                    merchantDataInfo.courses,
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
}
