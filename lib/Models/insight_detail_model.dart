// class ProductModel {
//   ProductModel({
//     this.id,
//     this.productName,
//     this.productImage,
//     this.productDescription,
//     this.productDetails,
//     this.productDetailsIndex,
//   });
//   int? id;
//   int? productDetailsIndex;
//   String? productName;

//   String? productImage;
//   dynamic productDescription;
//   List<ProductDetailModel>? productDetails;
// }

class InsightDetailModel {
  int? id;
  String? orderNo;
  double? orderAmt;
  double? orderComission;
  String? productCode;

  InsightDetailModel({
    this.id,
    this.productCode,
  });
}
