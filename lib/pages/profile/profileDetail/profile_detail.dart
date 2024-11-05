import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mos_beauty/pages/changePassword/change_password.dart';
import 'package:mos_beauty/pages/editProfile/edit_profile.dart';
import 'package:mos_beauty/pages/profile/profileDetail/profileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetails extends StatefulWidget {
  ProfileDetails({Key key}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ProfileUser profileUser;
  bool loading = true;

  @override
  void initState() {
    var jsons = {};
    ProfileModel().profileUserPhp(jsons).then((value) {
      setState(() {
        profileUser = value;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 1,
        title: Text(
          'Personal Info',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.18,
          ),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: kElevationToShadow[4],
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  height: 340,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileUser != null
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
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Full Name",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Date Of Birth",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "E-Mail",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Contact No",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        profileUser.fullName,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(profileUser.dob),
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                      Text(
                                        profileUser.email,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                      Text(
                                        profileUser.contactNo,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15.0,
                                          fontFamily: 'Karla',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontFamily: 'Karla',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, top: 5),
                          width: 300,
                          child: Text(profileUser.billingAddress),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonTheme(
                            minWidth: 150.0,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: OutlineButton(
                              child: Text('CHANGE PASSWORD',
                                  style: TextStyle(color: Colors.pink)),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.8,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ChangePassword(),
                                  ),
                                );
                              },
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 150.0,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: OutlineButton(
                              child: Text('EDIT PROFILE',
                                  style: TextStyle(color: Colors.pink)),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.8,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditProfile(
                                      profileUser: profileUser,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
