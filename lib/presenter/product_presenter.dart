import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_data.dart';

class ProductPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/product.php';

  // Mengambil daftar produk
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return (responseData['data'] as List)
              .map((item) => Product.fromJson(item))
              .toList();
        } else {
          throw Exception("API Error: ${responseData['message']}");
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch Products Error: $e');
      return [];
    }
  }

  // Menambahkan produk baru
  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Memperbarui produk
  Future<bool> updateProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Menghapus produk berdasarkan id_product
  Future<bool> deleteProduct(int idProduct) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl?id_product=$idProduct'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Mengambil daftar unit dari tabel unit
  Future<List<Unit>> fetchUnits() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?type=units'));
      final responseData = jsonDecode(response.body);
      print("Data Unit dari API: $responseData"); // Debugging

      if (responseData['status'] == 'success') {
        return (responseData['data'] as List)
            .map((item) => Unit.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error mengambil unit: $e');
      return [];
    }
  }

  // Mengambil daftar kategori dari tabel kategori
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?type=categories'));
      final responseData = jsonDecode(response.body);
      print("Data Kategori dari API: $responseData"); // Debugging
      if (responseData['status'] == 'success') {
        return (responseData['data'] as List)
            .map((item) => Category.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error mengambil kategori: $e');
      return [];
    }
  }
  
}
