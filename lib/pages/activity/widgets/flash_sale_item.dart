import 'package:flutter/material.dart';
import 'package:mos_beauty/models/flash_sale_model.dart';
import 'package:mos_beauty/pages/activity/widgets/discount_painter.dart';
import 'package:mos_beauty/utils/format.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FlashSaleItem extends StatelessWidget {
  final FlashSaleModel flashSale;

  const FlashSaleItem(this.flashSale);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("click");
      },
      child: Column(
        children: [
          Stack(
            children: [
              _buildProductImage(),
              if (flashSale.discountPercentage != 0) _buildDiscount(),
              if (flashSale.mall) _buildMall(),
            ],
          ),
          _buildPrice(),
          SizedBox(height: 8),
          _buildSold(),
        ],
      ),
    );
  }

  Image _buildProductImage() => Image.network(
        flashSale.image,
        height: 150,
        width: 150,
      );

  Positioned _buildDiscount() => Positioned(
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
                  "${flashSale.discountPercentage}%",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "Sale",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Container _buildMall() => Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Color(0xffd0011b),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          "Mall",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );

  RichText _buildPrice() => RichText(
        text: TextSpan(
          text: 'RM ',
          style: TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '${Format().currency(flashSale.price, decimal: true)}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );

  Stack _buildSold() {
    final percent = flashSale.sold / flashSale.qty;
    return Stack(
      overflow: Overflow.visible,
      children: [
        LinearPercentIndicator(
          center: Text(
            "Stock ${Format().currency(flashSale.sold.toDouble(), decimal: false)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          width: 130.0,
          lineHeight: 17.0,
          percent: percent,
          backgroundColor: Colors.grey[400],
          progressColor: Colors.deepOrange,
        ),
        //if (percent >= 0.5)
          // Positioned(
          //   top: -10,
          //   left: 4,
          //   child: SvgPicture.network(
          //     "https://image.flaticon.com/icons/svg/785/785116.svg",
          //     width: 20,
          //     height: 20,
          //   ),
          // ),
      ],
    );
  }
}
