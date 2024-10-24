class TotalItemSold {
  TotalItemSold({
    this.totalItemSold,
    this.topSelling,
  });
  String? totalItemSold;
  List<TopSellingModel>? topSelling;
}

class TopSellingModel {
  TopSellingModel({this.productImage, this.productName, this.totalSales});
  String? productImage;
  String? productName;
  String? totalSales;
}
