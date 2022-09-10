// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_item.dart';
import 'integrate_firebase.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};
  String urlStr = '/cartitems';

  late IntegrateFirebase firebase;

  Cart(BuildContext context) {
    firebase = Provider.of<IntegrateFirebase>(context, listen: false);
    firebase.setUrl = urlStr;
  }

  Map<String, CartItem> get cartItems {
    Map<String, CartItem> activeCartItems =
        Map<String, CartItem>.of(_cartItems);
    activeCartItems.removeWhere((key, value) => value.isActive == false);
    return activeCartItems;
  }

  Map<String, CartItem> get savedForLater {
    Map<String, CartItem> inactiveCartItems =
        Map<String, CartItem>.of(_cartItems);
    inactiveCartItems.removeWhere((key, value) => value.isActive == true);
    return inactiveCartItems;
  }

  double get cartTotal {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      if (cartItem.isActive) {
        total += cartItem.price * cartItem.quantity;
      }
    });
    return total;
  }

  int getItemQuantityOf(String id) {
    return _cartItems[id]?.quantity ?? 0;
  }

  Future<String?> fetchaAllCartItems() async {
    firebase.setUrlWithUser(urlStr, null);
    var serverCartItems = await firebase.get();
    if (serverCartItems.containsKey("errorMessage")) {
      return serverCartItems["errorMessage"];
    }
    _cartItems.clear();
    //_cartItems = serverCartItems["cartItems"];
    Map<String, dynamic>? cartJson = serverCartItems["cartItems"];
    if (cartJson != null) {
      cartJson.forEach(
        (key, value) {
          _cartItems.putIfAbsent(
            key,
            () => CartItem(
              value["quantity"],
              value["isActive"],
              value["price"],
            ),
          );
        },
      );
    }

    notifyListeners();
    return null;
  }

  Future<String?> addItemToCart(Product product) async {
    Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
    String? serverResponse;
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
        () => CartItem(
          1,
          true,
          product.price,
        ),
      );
    }
    notifyListeners();

    serverResponse = await updateFirebase();
    if (serverResponse != null) {
      _cartItems.clear();
      _cartItems.addAll(cartCopy);
      notifyListeners();
    }

    return serverResponse;
  }

  Future<String?> removeItemFromCart(Product product) async {
    String? response;
    Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
    _cartItems.remove(product.id);
    notifyListeners();
    response = await updateFirebase();
    if (response != null) {
      _cartItems.clear();
      _cartItems.addAll(cartCopy);
      notifyListeners();
    }
    return response;
  }

  Future<String?> removeSingleItemFromCart(Product product) async {
    String? response;
    Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);

    if ((_cartItems[product.id]?.quantity ?? 0) > 1) {
      _cartItems.update(
        product.id,
        (value) {
          value.quantity--;
          return value;
        },
      );
    } else {
      _cartItems.remove(product.id);
    }
    notifyListeners();

    response = await updateFirebase();
    if (response != null) {
      _cartItems.clear();
      _cartItems.addAll(cartCopy);
      notifyListeners();
    }

    return response;
  }

  Future<String?> clearCart() async {
    try {
      String? removeResponse;
      Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
      _cartItems.removeWhere((key, value) => value.isActive == true);
      notifyListeners();
      removeResponse = await updateFirebase();
      if (removeResponse != null) {
        // cartCopy.forEach((key, value) {
        //   _cartItems.putIfAbsent(key, () => value);
        // });
        _cartItems.addAll(cartCopy);
        notifyListeners();
      }
      return removeResponse;
    } catch (exception) {
      notifyListeners();
      return "Exception: $exception";
    }
  }

  Future<String?> clearCompleteCart() async {
    try {
      String? removeResponse;
      Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
      cartItems.clear();
      notifyListeners();
      removeResponse = await updateFirebase();
      if (removeResponse != null) {
        // cartCopy.forEach((key, value) {
        //   _cartItems.putIfAbsent(key, () => value);
        // });
        _cartItems.addAll(cartCopy);
        notifyListeners();
      }
      return removeResponse;
    } catch (exception) {
      notifyListeners();
      return "Exception: $exception";
    }
  }

  // Save For Later Functions

  Future<String?> addAllItemToCartFromSaveForLater() async {
    try {
      String? response;
      Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
      _cartItems.forEach((key, value) {
        value.isActive = true;
      });
      notifyListeners();
      response = await updateFirebase();
      if (response != null) {
        _cartItems.clear();
        _cartItems.addAll(cartCopy);
        notifyListeners();
      }
      return response;
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  Future<String?> addItemToCartFromSaveForLater(Product product) async {
    try {
      Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
      _cartItems[product.id]?.isActive = true;
      String? response;
      notifyListeners();
      response = await updateFirebase();
      if (response != null) {
        _cartItems.clear();
        _cartItems.addAll(cartCopy);
        notifyListeners();
      }
      return response;
    } on Exception catch (exception) {
      return "Exception: $exception";
    }
  }

  Future<String?> addItemToSaveForLater(Product product) async {
    try {
      Map<String, CartItem> cartCopy = Map<String, CartItem>.of(_cartItems);
      _cartItems[product.id]?.isActive = false;
      String? response;
      notifyListeners();
      response = await updateFirebase();
      if (response != null) {
        _cartItems.clear();
        _cartItems.addAll(cartCopy);
        notifyListeners();
      }
      return response;
    } on Exception catch (exception) {
      return "Exception: $exception";
    }
  }

  Future<String?> updateFirebase() async {
    firebase.setUrlWithUser(urlStr, null);
    var data = {
      "cartItems": _cartItems,
    };
    Map<String, dynamic> cartAddResponse = await firebase.patch(data, false);
    if (cartAddResponse.containsKey("errorMessage")) {
      return cartAddResponse["errorMessage"];
    }
    return null;
  }
}
