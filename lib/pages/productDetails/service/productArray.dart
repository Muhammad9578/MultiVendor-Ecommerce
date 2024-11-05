class ProductArray {
  ProductArray({
    this.productId,
    this.productCode,
    this.merchantId,
    this.name,
    this.shortDescription,
    this.description,
    this.sku,
    this.productCategoryId,
    this.productBrandId,
    this.productTag,
    this.startDate,
    this.endDate,
    this.publishStatus,
    this.currencyId,
    this.price,
    this.oldPrice,
    this.commission,
    this.buyButton,
    this.taxExempt,
    this.picture,
    this.status,
    this.addBy,
    this.addDate,
    this.quantity,
    this.quantityItem,
    this.totalPrice,
    this.selected,
    this.merchantName,
    this.merchantImage,
    this.totalDiscount,
    this.priceAfterDiscount,
  });

  String productId;
  String productCode;
  String merchantId;
  String name;
  String shortDescription;
  String description;
  String sku;
  String productCategoryId;
  String productBrandId;
  String productTag;
  DateTime startDate;
  DateTime endDate;
  String publishStatus;
  String currencyId;
  String price;
  String oldPrice;
  String commission;
  String buyButton;
  String taxExempt;
  String picture;
  String status;
  String addBy;
  DateTime addDate;
  String quantity;
  String merchantName;
  String merchantImage;
  double totalDiscount;
  double priceAfterDiscount;
  int quantityItem = 1;
  double totalPrice;
  bool selected = false;

  factory ProductArray.fromJson(Map<String, dynamic> json) => ProductArray(
        productId: json["product_id"],
        productCode: json["product_code"],
        merchantId: json["merchant_id"],
        name: json["name"],
        shortDescription: json["short_description"],
        description: json["description"],
        sku: json["sku"],
        productCategoryId: json["product_category_id"],
        productBrandId: json["product_brand_id"],
        productTag: json["product_tag"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        publishStatus: json["publish_status"],
        currencyId: json["currency_id"],
        price: json["price"],
        oldPrice: json["old_price"],
        commission: json["commission"],
        buyButton: json["buy_button"],
        taxExempt: json["tax_exempt"],
        picture: json["picture"],
        status: json["status"],
        addBy: json["add_by"],
        addDate: DateTime.parse(json["add_date"]),
        quantity: json["quantity"],
        merchantName: json["merchantName"],
        merchantImage: json["merchantImage"],
        totalDiscount: json["totalDiscount"].runtimeType == String
            ? double.parse(json["totalDiscount"])
            : json["totalDiscount"],
        priceAfterDiscount: json["priceAfterDiscount"] == String
            ? double.parse(json["priceAfterDiscount"])
            : json["totalDiscount"],
        quantityItem: 1,
        totalPrice: 0,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_code": productCode,
        "merchant_id": merchantId,
        "name": name,
        "short_description": shortDescription,
        "description": description,
        "sku": sku,
        "product_category_id": productCategoryId,
        "product_brand_id": productBrandId,
        "product_tag": productTag,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "publish_status": publishStatus,
        "currency_id": currencyId,
        "price": price,
        "old_price": oldPrice,
        "commission": commission,
        "buy_button": buyButton,
        "tax_exempt": taxExempt,
        "picture": picture,
        "status": status,
        "add_by": addBy,
        "add_date": addDate.toIso8601String(),
        "quantity": quantity,
        "merchantName": merchantName,
        "merchantImage": merchantImage,
        "totalDiscount": totalDiscount,
        "priceAfterDiscount": priceAfterDiscount
      };
}
