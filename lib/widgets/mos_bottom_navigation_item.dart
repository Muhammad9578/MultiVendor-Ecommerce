import 'package:flutter/material.dart';
import 'package:mos_beauty/Theme/yommie_theme.dart';
import 'package:mos_beauty/class/hex_color.dart';

class MosBottomNavigationItem extends StatelessWidget {
  const MosBottomNavigationItem({
    @required this.icon,
    this.iconActive,
    @required this.title,
    this.isActive = false,
    this.onTap,
    Key key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final IconData iconActive;
  final Function onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        child: Container(
          margin: EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              isActive
                  ? iconActive != null
                      ? Icon(
                          iconActive,
                          color: isActive ? HexColor('#75DFFF') : Colors.grey,
                        )
                      : Icon(
                          icon,
                          color: isActive ? HexColor('#75DFFF') : Colors.grey,
                        )
                  : Icon(
                      icon,
                      color: isActive ? HexColor('#75DFFF') : Colors.grey,
                    ),
              Spacer(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: YommieTheme.kMosBlackBoldSmall.copyWith(
                  color: isActive ? HexColor('#75DFFF') : Colors.grey,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
