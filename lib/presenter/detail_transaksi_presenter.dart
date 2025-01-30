import 'dart:convert';
import 'package:http/http.dart' as http;
import '../presenter/dashboard_presenter.dart';

class DetailTransaksiPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/detail_transaksi.php';
  final DashboardPresenter dashboardPresenter;

  DetailTransaksiPresenter(this.dashboardPresenter);

  /// **Mengambil detail transaksi terakhir berdasarkan user yang login**
  Future<Map<String, dynamic>?> fetchLastTransaction(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone_number': phoneNumber}),
      );

      print("🔵 Data transaksi yang diterima: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return responseData['data']; // Kembalikan data transaksi
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error: $e');
      return null;
    }
  }
}
