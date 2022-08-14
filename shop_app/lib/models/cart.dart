import 'package:flutter/material.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<String, Product> _cartItems = {};
  final Map<String, Product> _savedForLater = {};

  Map<String, Product> get cartItems {
    return _cartItems;
  }

  Map<String, Product> get savedForLater {
    return _savedForLater;
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

  int getItemQuantityOf(String id) {
    Product? prod = _cartItems[id];
    if (prod != null) {
      return prod.quantity;
    } else {
      return 0;
    }
  }

  String addItemToCart(Product product) {
    try {
      if (_cartItems.containsKey(product.id)) {
        _cartItems.update(product.id, (value) {
          value.quantity++;
          return value;
        });
      } else {
        _cartItems.putIfAbsent(product.id, () => product);
      }
      return "${product.title} added to the Card!";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  String addAllItemToCartFromSaveForLater() {
    try {
      _cartItems.addAll(_savedForLater);
      _savedForLater.clear();
      return "All Cart Products have been added to the Cart!";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  bool addItemToCartFromSaveForLater(Product product) {
    try {
      _cartItems.putIfAbsent(product.id, () => product);
      removeItemFromSavedForLater(product.id);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  bool addItemToSaveForLater(Product product) {
    try {
      _savedForLater.putIfAbsent(product.id, () => product);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  String removeItemFromCart(String productId) {
    try {
      Product? product = _cartItems[productId];
      String productName = product != null ? product.title : "No Name";
      _cartItems.remove(productId);
      return "Removed Product $productName from Cart";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  String removeSingleItemFromCart(String productId) {
    try {
      Product? product = _cartItems[productId];
      String productName = product != null ? product.title : "No Name";
      if (_cartItems.containsKey(productId) &&
          _cartItems[productId]!.quantity > 1) {
        _cartItems.update(productId, (value) {
          value.quantity--;
          return value;
        });
      } else {
        _cartItems.remove(productId);
      }
      return "Removed an Entry of $productName from Cart";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  bool removeItemFromSavedForLater(String productId) {
    try {
      _savedForLater.remove(productId);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  bool clearCart() {
    try {
      _cartItems.clear();
      return true;
    } catch (exception) {
      return false;
    } finally {
      notifyListeners();
    }
  }
}
