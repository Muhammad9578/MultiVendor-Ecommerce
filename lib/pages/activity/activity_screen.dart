

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mos_beauty/pages/activity/comment_page.dart';
import 'package:mos_beauty/pages/activity/post_page.dart';
import 'package:mos_beauty/pages/activity/services/activityModel.dart';
import 'package:mos_beauty/pages/home/widgets/header.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:mos_beauty/pages/OtherProfile/other_user_detail.dart';
import 'package:mos_beauty/pages/mall/service/adsModel.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profileModel.dart';
import 'package:mos_beauty/utils/pallete.dart';
import 'package:share/share.dart';


class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Widget> listFeed = [];
  List<MediaSocialData> mediaSocialData = [];
  bool loading = true;
  ProfileUser profileUser;
  List<AdsData> adsList;

  @override
  void initState() {
    _callApi();
    //_getDataMedia();
    super.initState();
  }

  _callApi() {
    var jsons = {};
    ActivityModel.activityModel(jsons).then((value) {
      AdsModel.adsPhp(jsons).then((value3) {
        ProfileModel().profileUserPhp(jsons).then((value2) {
          if (mounted) {
            setState(() {
              mediaSocialData = value;
              profileUser = value2;
              adsList = value3;
              loading = false;
            });
          }
        });
      });
    });
  }

  _getUserTypeImage(MediaSocialData item) {

    switch (item.userType) {
      case 'user':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'influencer':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/user/account/profile/pic/' +
                    item.userImage);
        break;
      case 'merchant':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/merchant/pic/' +
                    item.userImage);
        break;
      case 'staff':
        return item.userImage == ""
            ? CachedNetworkImageProvider(
                'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png')
            : CachedNetworkImageProvider(
                'https://mosbeauty.my/mos/pages/staff-merchant/pic/' +
                    item.userImage);
        break;
      default:
        return CachedNetworkImageProvider(
            'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            children: [
              HeaderBar(context: context),
              imageCarousel(),
              SizedBox(height: 8),
              myPost(),
              SizedBox(height: 8),
              Column(
                children: mediaSocialData.map((MediaSocialData item) {
                  bool isActive = false;
                  bool hasBorder = false;
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Palette.facebookBlue,
                                          child: CircleAvatar(
                                            radius: hasBorder ? 17.0 : 20.0,
                                            backgroundColor: Colors.grey[200],
                                            backgroundImage:
                                                _getUserTypeImage(item),
                                          ),
                                        ),
                                        isActive
                                            ? Positioned(
                                                bottom: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  height: 15.0,
                                                  width: 15.0,
                                                  decoration: BoxDecoration(
                                                    color: Palette.online,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 2.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){

                                              print('Profile picture Url ${item.userImage}');
                                              Navigator.push(context, new MaterialPageRoute(builder: (_)=>OtherUserDetail(item)));
                                            },
                                            child: Text(
                                              item.userName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                item.dateTime + '.',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Icon(
                                                Icons.public,
                                                color: Colors.grey[600],
                                                size: 12.0,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.more_horiz),
                                    //   onPressed: () {},
                                    // )
                                  ],
                                ),
                                SizedBox(height: 4.0),
                                Text(item.content),
                                item.mediaType != null
                                    ? const SizedBox.shrink()
                                    : const SizedBox(
                                        height: 6.0,
                                      ),
                              ],
                            ),
                          ),
                          item.mediaType != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child:
                                      // Image.network(
                                      //     'https://mosbeauty.my/mos.website/social-feed/uploads/' +
                                      //         item.mediaContent)
                                      CachedNetworkImage(
                                    imageUrl:
                                        'https://mosbeauty.my/mos.website/social-feed/uploads/' +
                                            item.mediaContent,
                                    // placeholder: (context, url) =>
                                    //     CircularProgressIndicator(),
                                    // errorWidget: (context, url, error) =>
                                    //     Icon(Icons.error),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Palette.facebookBlue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.thumb_up,
                                        size: 10.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Text(
                                        // '${post.likes}',
                                        '${item.countLike}',
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                    Text(
                                      //'${post.comments} Comments',
                                      '${item.countComment} Comments',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(width: 8.0),
                                    // Text(
                                    //   //'${post.shares} Shares',
                                    //   '2 Shares',
                                    //   style: TextStyle(color: Colors.grey[600]),
                                    // )
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    _PostButton(
                                      icon: Icon(
                                        MdiIcons.thumbUpOutline,
                                        color: item.doneLike
                                            ? Colors.blue
                                            : Colors.grey[600],
                                        size: 20.0,
                                      ),
                                      label: 'like',
                                      onTap: () {
                                        if (profileUser != null) {
                                          var jsons = {};
                                          jsons['post_id'] = item.id.toString();
                                          ActivityModel.socialLike(jsons)
                                              .then((value) {
                                            _callApi();
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "you must login first to like",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.pink,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                    ),
                                    _PostButton(
                                      icon: Icon(
                                        MdiIcons.commentOutline,
                                        color: Colors.grey[600],
                                        size: 20.0,
                                      ),
                                      label: 'Comment',
                                      onTap: () {
                                        if (profileUser != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CommentPage(
                                                      item, profileUser),
                                            ),
                                          ).then(
                                            (value) => _callApi(),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
                                            ),
                                          ).then((value) => _callApi());
                                        }
                                      },
                                    ),
                                    _PostButton(
                                      icon: Icon(
                                        MdiIcons.shareOutline,
                                        color: Colors.grey[600],
                                        size: 25.0,
                                      ),
                                      label: 'Share',
                                      onTap: () async {
                                        Share.share(
                                            'check out our apps https://example.com',
                                            subject: 'Look what I made!');

                                        // final response = await get(
                                        //     'https://mosbeauty.my/mos.website/social-feed/uploads/' +
                                        //         item.mediaContent);
                                        // final bytes = response.bodyBytes;
                                        // final Directory temp =
                                        //     await getTemporaryDirectory();
                                        // final File imageFile =
                                        //     File('${temp.path}/tempImage');
                                        // imageFile.writeAsBytesSync(
                                        //     response.bodyBytes);
                                        // Share.shareFiles(
                                        //   ['${temp.path}/tempImage'],
                                        //   text: 'text to share',
                                        // );
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ));
                }).toList(),
              ),
              // Column(
              //   children: listFeed,
              // ),
              SizedBox(height: 8),
            ],
          );
  }

  Container myPost() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      height: 100,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          profileUser != null
              ? ClipOval(
                  child: profileUser.image != ""
                      ? CachedNetworkImage(
                            height: 70,
                          width: 70,
                          imageUrl: 'https://mosbeauty.my/mos/pages/user/pic/' +
                              profileUser.image +
                              '?v=${DateTime.now().millisecondsSinceEpoch}')
                      : Image.asset(
                          'assets/images/placeholder-avatar.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                )
              : ClipOval(
                  child: Image.asset(
                    'assets/images/placeholder-avatar.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    width: double.infinity,
                    child: Center(
                      child: TextField(
                        onTap: () {
                          if (profileUser != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PostPage(havePost: false),
                              ),
                            ).then((value) => _callApi());
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(),
                              ),
                            ).then((value) => _callApi());
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "What's on your mind",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(30.0),
                          //     ),
                          //     border: Border.all(
                          //       color: Colors.grey,
                          //       width: 0.5,
                          //     ),
                          //   ),
                          //   height: 40,
                          //   width: 90,
                          //   child: Row(
                          //     children: [
                          //       SizedBox(width: 10),
                          //       Icon(
                          //         FontAwesomeIcons.video,
                          //         color: Colors.blue,
                          //         size: 16,
                          //       ),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         'Video',
                          //         style: TextStyle(
                          //             color: Colors.grey, fontSize: 14),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if (profileUser != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PostPage(havePost: false),
                                  ),
                                ).then((value) => _callApi());
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage(),
                                  ),
                                ).then((value) => _callApi());
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              height: 40,
                              width: 90,
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.images,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          )
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



class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final Function onTap;

  const _PostButton({Key key, this.icon, this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
