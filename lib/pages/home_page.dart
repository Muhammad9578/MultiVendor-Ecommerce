import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/home/home_screen.dart';
import 'package:mos_beauty/pages/inbox/inbox_page.dart';
import 'package:mos_beauty/pages/mall/mall_page.dart';
import 'package:mos_beauty/pages/profile/profile_page.dart';
import 'package:mos_beauty/widgets/mos_bottom_navigation_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity/activity_screen.dart';
import 'home/widgets/header.dart';
import 'login/login_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  HomePage(this.userId);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static ScrollController _hideButtonController;
  int _selectedIndex = 2;
  bool _isVisible = true;
  var userId;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ActivityScreen(),
    MallPage(),
    InboxPage(),
    ProfilePage(),
  ];

  final borderField = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  void initState() {
    super.initState();
    getUserId();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  @override
  void dispose() {
    _hideButtonController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  AnimatedContainer bottomNavigationBar(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 10),
      height: _isVisible ? MediaQuery.of(context).viewPadding.bottom + 70 : 0.0,
      child: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: MosBottomNavigationItem(
                  icon: FontAwesomeIcons.compass,
                  iconActive: FontAwesomeIcons.solidCompass,
                  title: "Activity",
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  isActive: _selectedIndex == 0,
                ),
              ),
              Expanded(
                child: MosBottomNavigationItem(
                  icon: FontAwesomeIcons.receipt,
                  title: "Home",
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  isActive: _selectedIndex == 1,
                ),
              ),
              Expanded(
                child: MosBottomNavigationItem(
                  icon: FontAwesomeIcons.storeAlt,
                  title: "Mall",
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  isActive: _selectedIndex == 2,
                ),
              ),
              Expanded(
                child: MosBottomNavigationItem(
                  icon: FontAwesomeIcons.inbox,
                  title: "Inbox",
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  isActive: _selectedIndex == 3,
                ),
              ),
              MosBottomNavigationItem(
                icon: FontAwesomeIcons.userCircle,
                iconActive: FontAwesomeIcons.solidUserCircle,
                title: "Account",
                onTap: () {
                  setState(() {
                    _selectedIndex = 4;
                  });
                },
                isActive: _selectedIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return CustomScrollView(
      controller: _hideButtonController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _widgetOptions.elementAt(_selectedIndex);
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  ListView viewMall() => ListView(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            child: Placeholder(),
          )
        ],
      );

  ListView viewHome() => ListView(
        children: [
          imageCarousel(),
        ],
      );

  Container imageCarousel() {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: 200.0,
      width: double.infinity,
      child: CarouselSlider(
        items: [
          'carousel0.jpg',
          'carousel1.jpg',
          'carousel2.jpg',
          'carousel3.jpeg'
        ].map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                "assets/images/" + i,
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

  Widget appBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.1 - 20,
        width: MediaQuery.of(context).size.width,
        child: headerTop(),
      ),
    );
  }

  Container headerTop() {
    return Container(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logo(),
          fieldSearch(),
          typeIcon(),
        ],
      ),
    );
  }

  Container typeIcon() {
    return Container(
      margin: EdgeInsets.only(left: 3, top: 10),
      child: Row(
        children: [
          SizedBox(width: 8),
          Icon(Icons.notifications, size: 30, color: Colors.black54),
          SizedBox(width: 4),
          Icon(FontAwesomeIcons.cartPlus, size: 24, color: Colors.black54),
          SizedBox(width: 18),
          Icon(FontAwesomeIcons.wallet, size: 24, color: Colors.black54),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Expanded fieldSearch() {
    return Expanded(
      child: Container(
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
    );
  }

  Container logo() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      width: 50,
      height: 45,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/MOSLogo-02.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
