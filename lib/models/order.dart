class Order {
  String id;
  List<String> productIds;
  String status; // Pending, Shipped, Delivered
  DateTime date;

  Order({required this.id, required this.productIds, required this.status, required this.date});
}
