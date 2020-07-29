class Item {
  final String id;
  final String userId;
  final int quantity;
  final int lowStock;
  final double price;
  final double discount;
  final double vat;
  final String name;
  final String imageUrl;
  final String imagePath;
  final String description;
  final String categoryId;
  final String storeId;
  final String sku;
  final String createdTime;
  final String createdDate;
  final String updatedTime;
  final String updatedDate;
  final bool isFavorite;

  Item({
    this.id,
    this.userId,
    this.quantity,
    this.lowStock,
    this.price,
    this.discount,
    this.vat,
    this.name,
    this.imageUrl,
    this.imagePath,
    this.description,
    this.categoryId,
    this.storeId,
    this.sku,
    this.createdTime,
    this.createdDate,
    this.updatedTime,
    this.updatedDate,
    this.isFavorite = false,
  });
}
