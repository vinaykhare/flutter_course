import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import 'selected_product.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    var scMessenger = ScaffoldMessenger.of(context);
    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _expanded ? widget.order.products.length * 100.0 : 80,
        child: Column(
          children: [
            ListTile(
              leading: Chip(
                label: Text(
                  widget.order.amount.toString(),
                ),
              ),
              title: Text(
                "${widget.order.products.entries.first.value.title}...",
              ),
              subtitle: Text(
                DateFormat('dd-mmm-yyyy hh:mm')
                    .format(widget.order.orderCreationDate),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(
                    () {
                      _expanded = !_expanded;
                    },
                  );
                },
                icon: _expanded
                    ? const Icon(
                        Icons.expand_less,
                      )
                    : const Icon(
                        Icons.expand_more,
                      ),
              ),
            ),
            //if (_expanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded ? widget.order.products.length * 40.0 : 0,
              child: ListView.builder(
                itemBuilder: (ctx, index) => SelectedProducts(
                  cartItem: widget.order.products.values.toList()[index],
                  allowEdit: false,
                  scMessenger: scMessenger,
                ),
                itemCount: widget.order.products.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
