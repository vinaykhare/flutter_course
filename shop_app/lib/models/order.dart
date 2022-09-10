import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'address.dart';

class Order with ChangeNotifier {
  String id;
  Address? deliveryAddress;
  Map<String, CartItem> products;
  DateTime orderCreationDate;
  double amount;

  Order({
    required this.id,
    required this.products,
    required this.orderCreationDate,
    required this.amount,
    this.deliveryAddress,
  }) : super();

  void setAddress(Address address) {
    deliveryAddress = address;
  }
}
