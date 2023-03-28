class MarkModel {
  MarkModel({
    required this.companyName,
    required this.physicalAddress,
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.ksTitle,
    required this.issueDate,
    required this.expiryDate,
    required this.ksNo,
  });

  String companyName;
  String physicalAddress;
  String productId;
  String productName;
  String productBrand;
  String ksTitle;
  String issueDate;
  String expiryDate;
  String ksNo;

  factory MarkModel.fromJson(Map<String, dynamic> json) => MarkModel(
        companyName: json["companyName"] ?? "",
        physicalAddress: json["physical_address"] ?? "",
        productId: json["product_id"] ?? "",
        productName: json["product_name"] ?? "",
        productBrand: json["product_brand"] ?? "",
        ksTitle: json["ks_title"] ?? "",
        issueDate:
            json["issue_date"] != "null" ? json["issue_date"] : "2000-01-01",
        expiryDate:
            json["expiry_date"] != 'null' ? json["expiry_date"] : "2000-01-01",
        ksNo: json["ks_NO"] ?? "",
      );
}
