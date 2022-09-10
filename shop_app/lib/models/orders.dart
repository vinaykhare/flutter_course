// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'order.dart';
import 'integrate_firebase.dart';
import 'cart_item.dart';
import 'address.dart';

class Orders with ChangeNotifier {
  final List<Order> _listOfOrders = [];
  String urlStr = '/orders';

  late IntegrateFirebase firebase;

  Orders(BuildContext context) {
    firebase = Provider.of<IntegrateFirebase>(context, listen: false);
    firebase.setUrl = urlStr;
  }

  List<Order> get allOrders {
    return [..._listOfOrders];
  }

  Future<String> fetchaAllOrders() async {
    firebase.setUrlWithUser(urlStr, "createdBy");
    var serverOrders = await firebase.get();
    if (serverOrders.containsKey("errorMessage")) {
      return serverOrders["errorMessage"];
    }
    _listOfOrders.clear();
    serverOrders.forEach((orderId, orderData) {
      Map<String, CartItem> productsFromServer = {};
      var productList = orderData["products"] as Map<String, dynamic>;
      productList.forEach((key, value) {
        productsFromServer.putIfAbsent(
          key,
          () => CartItem(
            value["quantity"],
            value["isActive"],
            value["price"],
          ),
        );
      });
      Order order = Order(
        id: orderId,
        amount: orderData["amount"],
        orderCreationDate: DateTime.parse(orderData["orderCreationDate"]),
        // products: {
        //   "orderindex": Product.fromJson(orderData["products"]),
        // },
        products: productsFromServer,
        deliveryAddress: Address.fromJson(orderData["deliveryAddress"]),
      );
      _listOfOrders.add(order);
    });

    notifyListeners();
    return "Orders Loaded Successfully";
  }

  Future<String?> addOrder(Cart cart, [Address? address]) async {
    var timestamp = DateTime.now();
    firebase.setUrl = urlStr;
    var addOrderResponse = await firebase.post(
      {
        "products": cart.cartItems,
        "orderCreationDate": timestamp.toIso8601String(),
        "amount": cart.cartTotal,
        "deliveryAddress": address,
      },
      true,
    );
    if (addOrderResponse.containsKey("errorMessage")) {
      return addOrderResponse["errorMessage"];
    }
    Order order = Order(
      id: addOrderResponse["name"],
      products: Map<String, CartItem>.from(cart.cartItems),
      orderCreationDate: timestamp,
      amount: cart.cartTotal,
    );
    address != null ? order.setAddress(address) : "";
    _listOfOrders.insert(
      0,
      order,
    );

    return null;
  }

  @override
  String toString() {
    String orderName = "No Orders are placed yet.";
    if (_listOfOrders.isNotEmpty) {
      orderName = _listOfOrders[0].products.values.toList().toString();
    }
    return orderName;
  }
}
