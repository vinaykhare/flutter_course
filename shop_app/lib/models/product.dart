import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;

  int quantity = 1;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  @override
  String toString() {
    return "Is $title favorite: $isFavorite";
  }
}
