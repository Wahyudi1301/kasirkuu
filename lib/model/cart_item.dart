class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_product": id.toString(),
      "jumlah": quantity.toString(),
      "total_price": (price * quantity).toString()
    };
  }
}
