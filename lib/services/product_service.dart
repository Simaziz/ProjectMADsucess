import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    final snapshot = await products.get();
    return snapshot.docs.map((doc) => Product(
        id: doc.id,
        name: doc['name'],
        description: doc['description'],
        price: doc['price'],
        imageUrl: doc['imageUrl'],
        stock: doc['stock']
    )).toList();
  }
}
