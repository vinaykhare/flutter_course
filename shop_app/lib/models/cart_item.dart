class CartItem {
  int quantity = 0;
  bool isActive = true;
  double price = 0.0;

  CartItem(this.quantity, this.isActive, this.price);

  Map<String, dynamic> toJson() {
    return {
      "quantity": quantity,
      "isActive": isActive,
      "price": price,
    };
  }

  CartItem.fromJson(Map<String, dynamic> json) {
    json.forEach(
      (key, value) {
        isActive = value["isActive"] ?? true;
        quantity = value["quantity"] ?? 5;
        price = value["price"] ?? 0.0;
      },
    );
  }
}
