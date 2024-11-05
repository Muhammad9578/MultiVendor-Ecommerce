import 'package:mos_beauty/models/flash_sale_model.dart';

class FlashSaleViewModel {
  List<FlashSaleModel> getFlashSale() {
    return [
      FlashSaleModel(
        image:
            "https://3.bp.blogspot.com/-lN1zEO5Bu7I/VkdQbdC0TdI/AAAAAAAAFGg/aN5MEGO1L5g/s1600/PhotoGrid_1447514203965.jpg",
        price: 50,
        discountPercentage: 50,
        qty: 1000,
        sold: 900,
        mall: true,
      ),
      FlashSaleModel(
        image:
            "https://media.ohbulan.com/wp-content/uploads/2018/10/compaq.jpg",
        price: 30,
        discountPercentage: 70,
        qty: 500,
        sold: 250,
      ),
      FlashSaleModel(
        image:
            "https://dewimalaysia.com/wp-content/uploads/2017/08/revlon.jpg",
        price: 320,
        discountPercentage: 30,
        qty: 50,
        sold: 10,
        mall: true,
      ),
      FlashSaleModel(
        image: "https://cf.shopee.com.my/file/a5d9f1a55a9ec557165819ead98e161c",
        price: 15,
        discountPercentage: 70,
        qty: 512,
        sold: 320,
      ),
    ];
  }
}
