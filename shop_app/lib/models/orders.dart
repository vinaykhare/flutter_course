// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart.dart';
import './order.dart';
import 'integrate_firebase.dart';
import 'product.dart';

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
    firebase.setUrl = urlStr;
    var serverOrders = await firebase.get();
    if (serverOrders.containsKey("errorMessage")) {
      return serverOrders["errorMessage"];
    }
    _listOfOrders.clear();
    serverOrders.forEach((orderId, orderData) {
      //print(orderData["products"]);
      Map<String, Product> productsFromServer = {};
      var productList = orderData["products"] as Map<String, dynamic>;
      productList.forEach((key, value) {
        productsFromServer.putIfAbsent(
          key,
          () => Product(
            id: value["id"],
            description: value["description"],
            imageUrl: value["imageUrl"],
            price: value["price"],
            title: value["title"],
            qty: value["quantity"],
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
      );
      _listOfOrders.add(order);
    });

    notifyListeners();
    return "Orders Loaded Successfully";
  }

  Future<String> addOrder(Cart cart) async {
    if (cart.cartItems.isEmpty) {
      return "Cart is Empty!";
    }

    var timestamp = DateTime.now();
    firebase.setUrl = urlStr;
    var addOrderResponse = await firebase.post(
      {
        "products": cart.cartItems,
        "orderCreationDate": timestamp.toIso8601String(),
        "amount": cart.cartTotal,
      },
      true,
    );
    if (addOrderResponse.containsKey("errorMessage")) {
      return addOrderResponse["errorMessage"];
    }

    _listOfOrders.insert(
      0,
      Order(
        id: addOrderResponse["name"],
        products: Map<String, Product>.from(cart.cartItems),
        orderCreationDate: timestamp,
        amount: cart.cartTotal,
      ),
    );

    return "Order Placed Successfully!";
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
