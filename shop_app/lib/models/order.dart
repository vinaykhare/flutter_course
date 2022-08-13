import 'package:flutter/foundation.dart';
import './product.dart';

class Order with ChangeNotifier {
  String id;
  Map<String, Product> products;
  DateTime orderCreationDate;
  double amount;

  Order({
    required this.id,
    required this.products,
    required this.orderCreationDate,
    required this.amount,
  }) : super();
}
