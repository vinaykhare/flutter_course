import 'package:flutter/material.dart';

import 'integrate_firebase.dart';
import 'product.dart';

class Cart with ChangeNotifier {
  final Map<String, Product> _cartItems = {};
  final Map<String, Product> _savedForLater = {};
  String urlStr = '/cartitems';

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
    IntegrateFirebase firebase = IntegrateFirebase(urlStr);

    var serverCartItems = await firebase.get();

    if (serverCartItems.containsKey("errorMessage")) {
      return serverCartItems["errorMessage"];
    }
    serverCartItems.forEach(
      (prodId, productData) {
        Product product = Product(
          id: prodId,
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          title: productData["title"],
          price: productData["price"],
        );
        product.isFavorite = productData["isFavorite"] ?? false;
        _cartItems.putIfAbsent(prodId, () => product);
      },
    );
    notifyListeners();
    return "Shopping Cart Loaded Successfully.";
  }

  Future<String> addItemToCart(Product product) async {
    try {
      var serverResponse = await addItemToCartOnServer(product);
      if (serverResponse.containsKey("errorMessage")) {
        return serverResponse["errorMessage"];
      }

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
          () => product,
        );
      }
      return "${product.title} added to the Cart!";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> addItemToCartOnServer(Product product) async {
    Map<String, dynamic> cartItemResponse = {};
    if (_cartItems.containsKey(product.id)) {
      IntegrateFirebase firebase = IntegrateFirebase("$urlStr/${product.id}");

      cartItemResponse = await firebase.patch(
        {
          "quantity": product.quantity + 1,
        },
      );
    } else {
      IntegrateFirebase firebase = IntegrateFirebase(urlStr);
      cartItemResponse = await firebase.post(
        {
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "quantity": product.quantity,
        },
      );
    }
    return cartItemResponse;
  }

  Future<String> removeItemFromCart(Product product) async {
    try {
      IntegrateFirebase firebase = IntegrateFirebase("$urlStr/${product.id}");
      var deleteItemResponse = await firebase.delete();
      if (deleteItemResponse.containsKey("errorMessage")) {
        return deleteItemResponse["errorMessage"];
      }
      _cartItems.remove(product.id);
      return "Removed Product ${product.title} from Cart";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  Future<String> removeSingleItemFromCart(Product cartItem) async {
    try {
      IntegrateFirebase firebase = IntegrateFirebase("$urlStr/${cartItem.id}");

      if (cartItem.quantity > 1) {
        var updateItemResponse = await firebase.patch(
          {
            "quantity": cartItem.quantity - 1,
          },
        );
        if (updateItemResponse.containsKey("errorMessage")) {
          return updateItemResponse["errorMessage"];
        }
        _cartItems.update(
          cartItem.id,
          (value) {
            value.quantity--;
            return value;
          },
        );
      } else {
        var deleteItemResponse = await firebase.delete();
        if (deleteItemResponse.containsKey("errorMessage")) {
          return deleteItemResponse["errorMessage"];
        }
        _cartItems.remove(cartItem.id);
      }
      return "Removed an Entry of ${cartItem.title} from Cart";
    } on Exception catch (exception) {
      return "Exception: $exception";
    } finally {
      notifyListeners();
    }
  }

  bool clearCart() {
    try {
      String removeResponse = "";
      cartItems.forEach((key, value) async {
        removeResponse += await removeItemFromCart(value);
      });
      return removeResponse == "";
    } catch (exception) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Save For Later Functions

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
}
