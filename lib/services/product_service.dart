import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('products');

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await products.get(GetOptions(source: Source.server));
      print('Fetched ${snapshot.docs.length} products'); // debug
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}
