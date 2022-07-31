import 'package:flutter/material.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<String, Product> _cartItems = {};

  Map<String, Product> get cartItems {
    return _cartItems;
  }

  int get numberOfCartItems {
    return _cartItems.length;
  }

  double get cartTotal {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  bool addItemToCart(Product product) {
    try {
      if (_cartItems.containsKey(product.id)) {
        _cartItems.update(product.id, (value) {
          value.quantity++;
          return value;
        });
      } else {
        _cartItems.putIfAbsent(product.id, () => product);
      }
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  bool removeItemFromCart(String productId) {
    try {
      _cartItems.remove(productId);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }
}
