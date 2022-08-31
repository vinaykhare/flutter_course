// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'integrate_firebase.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<String, Product> _cartItems = {};
  final Map<String, Product> _savedForLater = {};
  String urlStr = '/cartitems';

  late IntegrateFirebase firebase;

  Cart(BuildContext context) {
    firebase = Provider.of<IntegrateFirebase>(context, listen: false);
    firebase.setUrl = urlStr;
  }

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

  Future<String> fetchaAllCartItems() async {
    _savedForLater.clear();
    _cartItems.clear();
    firebase.setUrlWithUser(urlStr, null);
    var serverCartItems = await firebase.get();
    if (serverCartItems.containsKey("errorMessage")) {
      return serverCartItems["errorMessage"];
    }
    //_cartItems = serverCartItems["cartItems"];
    Map<String, dynamic>? cartJson = serverCartItems["cartItems"];
    if (cartJson != null) {
      cartJson.forEach(
        (key, value) {
          _cartItems.putIfAbsent(
            key,
            () => Product(
              createdBy: value["createdBy"],
              description: value["description"],
              id: value["id"],
              imageUrl: value["imageUrl"],
              price: value["price"],
              qty: value["quantity"],
              title: value["title"],
            ),
          );
        },
      );
    }
    Map<String, dynamic>? saveForLaterJson = serverCartItems["savedForLater"];
    if (saveForLaterJson != null) {
      saveForLaterJson.forEach(
        (key, value) {
          _savedForLater.putIfAbsent(
            key,
            () => Product(
              createdBy: value["createdBy"],
              description: value["description"],
              id: value["id"],
              imageUrl: value["imageUrl"],
              price: value["price"],
              qty: value["quantity"],
              title: value["title"],
            ),
          );
        },
      );
    }
    // serverCartItems.forEach(
    //   (prodId, productData) {
    //     Product product = Product(
    //       id: prodId,
    //       description: productData["description"],
    //       imageUrl: productData["imageUrl"],
    //       title: productData["title"],
    //       price: productData["price"],
    //     );
    //     product.isFavorite = productData["isFavorite"] ?? false;
    //     _cartItems.putIfAbsent(prodId, () => product);
    //   },
    // );
    notifyListeners();
    return "Shopping Cart Loaded Successfully.";
  }

  Future<void> addItemToCart(Product product) async {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(
        product.id,
        (value) {
          value.quantity++;
          return value;
        },
      );
    } else {
      _cartItems.putIfAbsent(
        product.id,
        () => Product(
          id: product.id,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title,
        ),
      );
    }
    await updateFirebase();
    notifyListeners();
  }

  Future<String> removeItemFromCart(Product product) async {
    _cartItems.remove(product.id);
    await updateFirebase();
    notifyListeners();
    return "";
  }

  Future<String> removeSingleItemFromCart(Product cartItem) async {
    if (cartItem.quantity > 1) {
      _cartItems.update(
        cartItem.id,
        (value) {
          value.quantity--;
          return value;
        },
      );
    } else {
      _cartItems.remove(cartItem.id);
    }
    await updateFirebase();
    notifyListeners();
    return "Single Item removed from Cart!";
  }

  Future<bool> clearCart() async {
    try {
      String removeResponse = "";
      cartItems.clear();
      await updateFirebase();
      return removeResponse == "";
    } catch (exception) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Save For Later Functions

  Future<String> addAllItemToCartFromSaveForLater() async {
    try {
      _cartItems.addAll(_savedForLater);
      _savedForLater.clear();
      await updateFirebase();
      return "All Cart Products have been added to the Cart!";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  Future<bool> addItemToCartFromSaveForLater(Product product) async {
    try {
      _cartItems.putIfAbsent(product.id, () => product);
      removeItemFromSavedForLater(product.id);
      await updateFirebase();
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> addItemToSaveForLater(Product product) async {
    try {
      _savedForLater.putIfAbsent(product.id, () => product);
      await updateFirebase();
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> removeItemFromSavedForLater(String productId) async {
    try {
      _savedForLater.remove(productId);
      await updateFirebase();
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateFirebase() async {
    firebase.setUrlWithUser(urlStr, null);
    var data = {
      "cartItems": _cartItems,
      "savedForLater": _savedForLater,
    };
    Map<String, dynamic> cartAddResponse = await firebase.patch(data, false);
    if (cartAddResponse.containsKey("errorMessage")) {
      return cartAddResponse["errorMessage"];
    }
  }
}
