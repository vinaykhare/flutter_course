import 'package:flutter/foundation.dart';
import './cart.dart';
import './order.dart';
import 'product.dart';

class Orders with ChangeNotifier {
  final List<Order> _listOfOrders = [];

  List<Order> get allOrders {
    return [..._listOfOrders];
  }

  String addOrder(Cart cart) {
    if (cart.cartItems.isEmpty) {
      return "Cart is Empty!";
    }
    _listOfOrders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        products: Map<String, Product>.from(cart.cartItems),
        orderCreationDate: DateTime.now(),
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
