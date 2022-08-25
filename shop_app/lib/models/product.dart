import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  String _id = DateTime.now().toString(),
      _title = "",
      _description = "",
      _imageUrl = "";
  double _price = 0.0;

  int quantity = 1;
  bool isFavorite = false;

  Product({
    id,
    title,
    description,
    price,
    imageUrl,
    qty,
  }) {
    _id = id ?? DateTime.now().toString();
    _title = title ?? "";
    _description = description ?? "";
    _imageUrl = imageUrl ?? "";
    _price = price ?? 0.0;
    quantity = qty ?? 1;
  }

  set setId(id) {
    _id = id;
  }

  set setTitle(title) {
    _title = title;
  }

  set setDescription(description) {
    _description = description;
  }

  set setImageUrl(imageUrl) {
    _imageUrl = imageUrl;
  }

  set setPrice(price) {
    _price = price;
  }

  String get id {
    return _id;
  }

  String get title {
    return _title;
  }

  String get description {
    return _description;
  }

  String get imageUrl {
    return _imageUrl;
  }

  double get price {
    return _price;
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  @override
  String toString() {
    return "Is $_title of price $price with Id: $id favorite: $isFavorite";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
      "quantity": quantity,
    };
  }

  Product.fromJson(Map<String, dynamic> json) {
    json.forEach(
      (key, value) {
        _id = key;
        _title = value["title"] ?? "";
        _description = value["dscription"] ?? "";
        _imageUrl = value["imageUrl"] ?? "";
        _price = value["price"] ?? 0.0;
        quantity = value["quantity"] ?? 1;
      },
    );
  }
}
