
class Product {
    Product({
        this.serviceId,
        this.serviceCode,
        this.merchantId,
        this.name,
        this.gender,
        this.serviceCategoryId,
        this.subCategoryId,
        this.tagline,
        this.shortDesc,
        this.description,
        this.duration,
        this.durationType,
        this.currencyId,
        this.cost,
        this.currencyIdMember,
        this.costMember,
        this.commission,
        this.publishStatus,
        this.buyButton,
        this.taxExempt,
        this.image,
        this.status,
        this.addBy,
        this.dateAdd,
        this.sessionPackage,
    });

    String serviceId;
    String serviceCode;
    String merchantId;
    String name;
    String gender;
    String serviceCategoryId;
    String subCategoryId;
    String tagline;
    String shortDesc;
    String description;
    String duration;
    String durationType;
    String currencyId;
    String cost;
    String currencyIdMember;
    String costMember;
    String commission;
    String publishStatus;
    String buyButton;
    String taxExempt;
    String image;
    String status;
    String addBy;
    DateTime dateAdd;
    String sessionPackage;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        serviceId: json["service_id"],
        serviceCode: json["service_code"],
        merchantId: json["merchant_id"],
        name: json["name"],
        gender: json["gender"],
        serviceCategoryId: json["service_category_id"],
        subCategoryId: json["sub_category_id"],
        tagline: json["tagline"],
        shortDesc: json["short_desc"],
        description: json["description"],
        duration: json["duration"],
        durationType: json["duration_type"],
        currencyId: json["currency_id"],
        cost: json["cost"],
        currencyIdMember: json["currency_id_member"],
        costMember: json["cost_member"],
        commission: json["commission"],
        publishStatus: json["publish_status"],
        buyButton: json["buy_button"],
        taxExempt: json["tax_exempt"],
        image: json["image"],
        status: json["status"],
        addBy: json["add_by"],
        dateAdd: DateTime.parse(json["date_add"]),
        sessionPackage: json["session_package"],
    );

    Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_code": serviceCode,
        "merchant_id": merchantId,
        "name": name,
        "gender": gender,
        "service_category_id": serviceCategoryId,
        "sub_category_id": subCategoryId,
        "tagline": tagline,
        "short_desc": shortDesc,
        "description": description,
        "duration": duration,
        "duration_type": durationType,
        "currency_id": currencyId,
        "cost": cost,
        "currency_id_member": currencyIdMember,
        "cost_member": costMember,
        "commission": commission,
        "publish_status": publishStatus,
        "buy_button": buyButton,
        "tax_exempt": taxExempt,
        "image": image,
        "status": status,
        "add_by": addBy,
        "date_add": "${dateAdd.year.toString().padLeft(4, '0')}-${dateAdd.month.toString().padLeft(2, '0')}-${dateAdd.day.toString().padLeft(2, '0')}",
        "session_package": sessionPackage,
    };
}
