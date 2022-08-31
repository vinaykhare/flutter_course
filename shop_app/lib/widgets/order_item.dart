import 'dart:math';

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
    return Column(
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
                    Icons.expand_more,
                  )
                : const Icon(
                    Icons.expand_less,
                  ),
          ),
        ),
        if (_expanded)
          SizedBox(
            height: min(widget.order.products.length * 20.0 + 100, 180),
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
    );
  }
}
