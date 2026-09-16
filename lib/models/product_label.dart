class ProductLabel {
  final String rawText;
  final String? extractedBrand;
  final String? extractedProductName;
  final String? extractedMrp;
  final String? extractedMfgDate;
  final String? extractedNetQuantity;

  ProductLabel({
    required this.rawText,
    this.extractedBrand,
    this.extractedProductName,
    this.extractedMrp,
    this.extractedMfgDate,
    this.extractedNetQuantity,
  });
}
