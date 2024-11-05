import 'package:flutter/material.dart';

class MosIcon extends StatelessWidget {
  const MosIcon({
    Key key,
    @required this.title,
    @required this.image,
    @required this.onTap,
    this.size = 60,
  }) : super(key: key);

  final String title;
  final String image;
  final double size;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Image(
            height: size,
            image: AssetImage(image),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Sanomat Grab Web',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
