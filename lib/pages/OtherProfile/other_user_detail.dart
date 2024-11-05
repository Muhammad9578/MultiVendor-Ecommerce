import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mos_beauty/models/FollowModel.dart';
import 'package:mos_beauty/pages/activity/services/activityModel.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mos_beauty/pages/chat/chatScreen.dart';

class OtherUserDetail extends StatefulWidget {
  MediaSocialData items;

  OtherUserDetail(this.items);

  @override
  _OtherUserDetailState createState() => _OtherUserDetailState();
}

class _OtherUserDetailState extends State<OtherUserDetail> {
  String userId;
  String currentUserName;
  String currentUserImage;
  bool following=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUserId();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white30,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 80.0,left: 50.0,right: 50.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(
                    widget.items.userImage==""?'https://mosbeauty.my/mos.website/assets/img/MOSLogo-01-logo.png':'https://mosbeauty.my/mos.website/user/account/profile/pic/'+'${widget.items.userImage}'
                ),
              ),
            ),
            SizedBox(height:30.0),
            Text(
              widget.items.userName,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),
            const Divider(),
            Row(
              children: [
                _PostButton(
                  icon: Icon(
                    MdiIcons.accountHeart,
                    color: widget.items.doneLike
                        ? Colors.blue
                        : Colors.grey[600],
                    size: 20.0,
                  ),
                  label: 'Follow',
                  onTap: () {
                    if ( userId!= null) {
                      var jsons = {};
                      jsons["user_id"] = widget.items.id;
                      jsons["followby"] = userId;
                      FollowModel.followPhp(jsons, context).then((value) {
                        print('value at viewshop is $value');
                        setState(() {
                          following = true;
                        });

                        // print(" value at login $value");
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
                  label: 'Message',
                  onTap: () {

                    if (userId != null) {
                      Navigator.push(context, new MaterialPageRoute(builder: (_)=>ChatScreen(serviceProviderId: widget.items.id,userName: widget.items.userName,avatarUrl: 'https://mosbeauty.my/mos.website/user/account/profile/pic/'+'${widget.items.userImage}',currentUserId:userId,currentUserName:currentUserName,currentUserImage:currentUserImage)));
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
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  void getCurrentUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() {
      userId=prefs.getString('userId');
      currentUserName=prefs.getString('userName');
      
      currentUserImage=prefs.getString("image");
    });

    var jsons = {};
    jsons["user_id"] = widget.items.id;
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