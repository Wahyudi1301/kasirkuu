import 'dart:convert';
import 'package:http/http.dart' as http;
import '../presenter/dashboard_presenter.dart';

class RiwayatTransaksiPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/riwayat_transaksi.php';
  final DashboardPresenter dashboardPresenter;

  RiwayatTransaksiPresenter(this.dashboardPresenter);

  /// **Mengambil riwayat transaksi berdasarkan id_store dari user yang login**
  Future<List<Map<String, dynamic>>> fetchRiwayatTransaksi(
      String phoneNumber) async {
    try {
      // Kirim permintaan ke server untuk mendapatkan riwayat transaksi
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber
        }), // ✅ Gunakan phone_number, bukan id_store
      );

      print("🔵 Respon dari server: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error: $e');
      return [];
    }
  }
}
