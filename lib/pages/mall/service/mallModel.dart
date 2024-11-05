import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class MallModel {
  static Future<MallType> mallDataPhp(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'mall_data.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final mallType = mallTypeFromJson(response);
        return mallType;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

MallType mallTypeFromJson(String str) => MallType.fromJson(json.decode(str));

String mallTypeToJson(MallType data) => json.encode(data.toJson());

class MallType {
    MallType({
        this.countItem,
        this.categotyItem,
    });

    CountItem countItem;
    CategotyItem categotyItem;

    factory MallType.fromJson(Map<String, dynamic> json) => MallType(
        countItem: CountItem.fromJson(json["countItem"]),
        categotyItem: CategotyItem.fromJson(json["categotyItem"]),
    );

    Map<String, dynamic> toJson() => {
        "countItem": countItem.toJson(),
        "categotyItem": categotyItem.toJson(),
    };
}

class CategotyItem {
    CategotyItem({
        this.categoryProduct,
        this.categoryService,
        this.categoryCourses,
    });

    List<CategoryProduct> categoryProduct;
    List<CategoryService> categoryService;
    List<CategoryCourse> categoryCourses;

    factory CategotyItem.fromJson(Map<String, dynamic> json) => CategotyItem(
        categoryProduct: List<CategoryProduct>.from(json["categoryProduct"].map((x) => CategoryProduct.fromJson(x))),
        categoryService: List<CategoryService>.from(json["categoryService"].map((x) => CategoryService.fromJson(x))),
        categoryCourses: List<CategoryCourse>.from(json["categoryCourses"].map((x) => CategoryCourse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categoryProduct": List<dynamic>.from(categoryProduct.map((x) => x.toJson())),
        "categoryService": List<dynamic>.from(categoryService.map((x) => x.toJson())),
        "categoryCourses": List<dynamic>.from(categoryCourses.map((x) => x.toJson())),
    };
}

class CategoryCourse {
    CategoryCourse({
        this.coursesCategoryId,
        this.name,
        this.banner,
        this.icon,
        this.detail,
        this.term,
        this.courseTag,
        this.activeStatus,
        this.status,
    });

    dynamic coursesCategoryId;
    String name;
    String banner;
    String icon;
    String detail;
    String term;
    String courseTag;
    String activeStatus;
    String status;

    factory CategoryCourse.fromJson(Map<String, dynamic> json) => CategoryCourse(
        coursesCategoryId: json["courses_category_id"],
        name: json["name"],
        banner: json["banner"],
        icon: json["icon"],
        detail: json["detail"],
        term: json["term"],
        courseTag: json["course_tag"],
        activeStatus: json["active_status"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "courses_category_id": coursesCategoryId,
        "name": name,
        "banner": banner,
        "icon": icon,
        "detail": detail,
        "term": term,
        "course_tag": courseTag,
        "active_status": activeStatus,
        "status": status,
    };
}

class CategoryProduct {
    CategoryProduct({
        this.productCategoryId,
        this.name,
        this.parentCategoryId,
        this.icon,
        this.banner,
        this.description,
        this.displayOrder,
        this.seoName,
        this.seoMetaTitle,
        this.seoMetaKeywords,
        this.seoMetaDescriptions,
        this.status,
        this.dateAdd,
        this.addBy,
    });

    String productCategoryId;
    String name;
    String parentCategoryId;
    String icon;
    String banner;
    String description;
    String displayOrder;
    String seoName;
    String seoMetaTitle;
    String seoMetaKeywords;
    dynamic seoMetaDescriptions;
    String status;
    DateTime dateAdd;
    String addBy;

    factory CategoryProduct.fromJson(Map<String, dynamic> json) => CategoryProduct(
        productCategoryId: json["product_category_id"],
        name: json["name"],
        parentCategoryId: json["parent_category_id"],
        icon: json["icon"],
        banner: json["banner"],
        description: json["description"],
        displayOrder: json["display_order"],
        seoName: json["seo_name"],
        seoMetaTitle: json["seo_meta_title"],
        seoMetaKeywords: json["seo_meta_keywords"],
        seoMetaDescriptions: json["seo_meta_descriptions"],
        status: json["status"],
        dateAdd: DateTime.parse(json["date_add"]),
        addBy: json["add_by"],
    );

    Map<String, dynamic> toJson() => {
        "product_category_id": productCategoryId,
        "name": name,
        "parent_category_id": parentCategoryId,
        "icon": icon,
        "banner": banner,
        "description": description,
        "display_order": displayOrder,
        "seo_name": seoName,
        "seo_meta_title": seoMetaTitle,
        "seo_meta_keywords": seoMetaKeywords,
        "seo_meta_descriptions": seoMetaDescriptions,
        "status": status,
        "date_add": dateAdd.toIso8601String(),
        "add_by": addBy,
    };
}

class CategoryService {
    CategoryService({
        this.serviceCategoryId,
        this.name,
        this.banner,
        this.icon,
        this.detail,
        this.activeStatus,
        this.status,
        this.addBy,
        this.dateAdd,
    });

    String serviceCategoryId;
    String name;
    String banner;
    String icon;
    String detail;
    String activeStatus;
    String status;
    String addBy;
    DateTime dateAdd;

    factory CategoryService.fromJson(Map<String, dynamic> json) => CategoryService(
        serviceCategoryId: json["service_category_id"],
        name: json["name"],
        banner: json["banner"],
        icon: json["icon"],
        detail: json["detail"],
        activeStatus: json["active_status"],
        status: json["status"],
        addBy: json["add_by"],
        dateAdd: DateTime.parse(json["date_add"]),
    );

    Map<String, dynamic> toJson() => {
        "service_category_id": serviceCategoryId,
        "name": name,
        "banner": banner,
        "icon": icon,
        "detail": detail,
        "active_status": activeStatus,
        "status": status,
        "add_by": addBy,
        "date_add": dateAdd.toIso8601String(),
    };
}

class CountItem {
    CountItem({
        this.courses,
        this.product,
        this.service,
    });

    String courses;
    String product;
    String service;

    factory CountItem.fromJson(Map<String, dynamic> json) => CountItem(
        courses: json["courses"],
        product: json["product"],
        service: json["service"],
    );

    Map<String, dynamic> toJson() => {
        "courses": courses,
        "product": product,
        "service": service,
    };
}
