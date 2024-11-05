import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mos_beauty/pages/Cart/cart_page.dart';
import 'package:mos_beauty/pages/login/login_page.dart';
import 'package:mos_beauty/pages/walletPoint/walletPoint_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;
  final borderField = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border(
          //   bottom: BorderSide(
          //     color: Colors.grey,
          //     width: 1.0,
          //   ),
          // ),
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
          SizedBox(width: 20),
          InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userId = prefs.getString('userId');
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WalletPoint(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                }
              },
              child: Icon(FontAwesomeIcons.wallet,
                  size: 24, color: Colors.black54)),
          SizedBox(width: 20),
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
