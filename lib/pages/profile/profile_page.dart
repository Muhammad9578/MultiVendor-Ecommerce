import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/class/hex_color.dart';
import 'package:mos_beauty/models/FollowerModel.dart';
import 'package:mos_beauty/pages/home/widgets/header.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:mos_beauty/pages/mall/mall_page.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profileModel.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profile_detail.dart';
import 'package:mos_beauty/pages/referral/referral_page.dart';
import 'package:mos_beauty/pages/walletPoint/walletPoint_page.dart';
import 'package:mos_beauty/provider/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  ProfileUser profileUser;
  var userId;
  bool loading = true;

  @override
  void initState() {
    _controller = new TabController(length: 2, vsync: this);
    getUserId();


    super.initState();
  }

  getUserId() async {
    var jsons = {};
    ProfileModel().profileUserPhp(jsons).then((value2) async {
      print('Mounted ?  $mounted and value2 at profile page $value2');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mounted) {

        setState(() {
          profileUser = value2;
          loading = false;
          userId = prefs.getString('userId');
        });
      }
    }).then((value) => getFollower());


  }

  @override
  Widget build(BuildContext context) {
    // getFollower(context);
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
              profileUser != null
                  ? Container(
                      color: Colors.white,
                      padding:
                          const EdgeInsets.only(left: 25, bottom: 25, top: 70),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileUser.image  != null
                              ? ClipOval(
                                  child: profileUser.image != ""
                                      ? CachedNetworkImage(
                                          height: 70,
                                          width: 70,
                                          imageUrl:
                                              'https://mosbeauty.my/mos/pages/user/pic/' +
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
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                profileUser.userName,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54),
                              ),
                              Text(
                                'Follower 0 | Following 0',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(color: HexColor('#75DFFF')),
                child: TabBar(
                  labelColor: Colors.white,
                  controller: _controller,
                  tabs: [
                    Tab(
                      text: 'Buying',
                    ),
                    Tab(
                      text: 'Posts',
                    ),
                  ],
                ),
              ),
              Container(
                height: 400.0,
                child: new TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    TabBar1(userId),
                    TabBar2(),
                  ],
                ),
              ),
            ],
          );
  }

  void getFollower() {


    var jsons = {};
    jsons["user_id"] = '$userId';
    FollowerModel.followerPhp(jsons).then((value) {
      print("value at profile_page $value");
    });
  }
}

class TabBar1 extends StatelessWidget {
  var userId;
  TabBar1(this.userId);

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    print("currentUserId $userId");
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          color: Colors.white,
          child: Column(
            children: [
              buildListTile("Wallet", FontAwesomeIcons.wallet, () {
                if (userId != null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WalletPoint(),
                    ),
                  ).then((value) => getUserId());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  ).then((value) => getUserId());
                }
              }),
              buildListTile("Refer a Friend", FontAwesomeIcons.userFriends, () {
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ReferralPage(),
                    ),
                  ).then((value) => getUserId());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  ).then((value) => getUserId());
                }
              }),
              buildListTile("My Profile", FontAwesomeIcons.userCircle, () {
                if (userId != null) { 
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProfileDetails(),
                    ),
                  ).then((value) => getUserId());
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  ).then((value) => getUserId());
                }
              }),
              // buildListTile("My Calendar", FontAwesomeIcons.calendar, () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (BuildContext context) => CalendarPage(),
              //     ),
              //   );
              // }),
              userId != null
                  ? buildListTile("Logout", FontAwesomeIcons.signOutAlt,
                      () async {
                      final pref = await SharedPreferences.getInstance();
                      await pref.clear();
                      GetAPI.setupHTTPHeader(null);
                      showAlertDialogTwoButton(
                          context, 'Successfully log out ✓', () {
                        Navigator.of(context).pop();
                      });
                      userId = null;
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => LoginPage(),
                      //   ),
                      // );
                    })
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  showAlertDialogTwoButton(BuildContext context, title, Function onPressed) {
    // set up the buttons
    Widget okButton = FlatButton(
        child: Text("Ok", style: TextStyle(color: HexColor('#75DFFF'))),
        onPressed: onPressed);

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ListTile buildListTile(
    String title,
    IconData icon,
    Function onTap,
  ) {
    if (title == "Wallet") {
      return ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 22,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      );
    } else {
      return ListTile(
        onTap: onTap,
        leading: Icon(icon, size: 22),
        title: Text(title),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      );
    }
  }
}

class TabBar2 extends StatelessWidget {
  const TabBar2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          color: Colors.white,
          alignment: Alignment.center,
          child: Text("No post yet"),
        ),
      ],
    );
  }
}
