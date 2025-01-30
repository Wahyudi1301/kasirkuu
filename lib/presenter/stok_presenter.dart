import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/stock_data.dart';

class StockPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/stok.php';

  Future<List<Stock>> getStock() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?getStock'));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return (responseData['data'] as List)
              .map((item) => Stock.fromMap(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching stock: $e");
      return [];
    }
  }

  Future<bool> updateStock(int idProduct, int stokBaru) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?updateStock'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_product': idProduct,
          'stok_baru': stokBaru,
        }),
      );

      final responseData = jsonDecode(response.body);
      return responseData['status'] == 'success';
    } catch (e) {
      print("Error updating stock: $e");
      return false;
    }
  }
}
