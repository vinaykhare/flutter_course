import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/integrate_firebase.dart';

class Product with ChangeNotifier {
  String _id = DateTime.now().toString(),
      _title = "",
      _description = "",
      _imageUrl = "",
      _createdBy = "system";
  double _price = 100.0;
  Uint8List _image = Uint8List.fromList([]);

  int quantity = 1;
  bool isFavorite = false;

  String urlStr = '/favorites/';

  Product({
    id,
    title,
    description,
    price,
    imageUrl,
    createdBy,
    qty,
    image,
  }) {
    _id = id ?? DateTime.now().toString();
    _title = title ?? "";
    _description = description ?? "";
    _imageUrl = imageUrl ?? "";
    _price = price ?? 0.0;
    _createdBy = createdBy ?? _createdBy;
    quantity = qty ?? 1;
    _image = image ?? Uint8List.fromList([]);
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

  set createdBy(user) {
    _createdBy = user;
  }

  set setImage(Uint8List img) {
    _image = img;
  }

  Uint8List get image {
    return _image;
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

  String get createdBy {
    return _createdBy;
  }

  Future<String?> toggleFavorite(BuildContext context) async {
    IntegrateFirebase firebase =
        Provider.of<IntegrateFirebase>(context, listen: false);
    firebase.setUrlWithUser(urlStr, null);
    Map<String, dynamic> response = await firebase.patch({
      id: !isFavorite,
    }, false);
    if (response.containsKey("errorMessage")) {
      return response["errorMessage"];
    }
    isFavorite = !isFavorite;
    notifyListeners();
    return null;
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
      "createdBy": createdBy,
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
        _createdBy = value["createdBy"];
        quantity = value["quantity"] ?? 1;
        isFavorite = value["isFavorite"];
      },
    );
  }
}
