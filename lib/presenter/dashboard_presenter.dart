import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/dashboard.php';

  Future<Map<String, dynamic>?> fetchDashboardData(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone_number': phoneNumber}),
      );

      print("Response Body: ${response.body}"); // Debug response dari API

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return {
            "user_full_name": responseData['data']['user_full_name'],
            "user_phone_number": responseData['data']['user_phone_number'],
            "user_status": responseData['data']['user_status'],
            "id_store": responseData['data']
                ['id_store'], // ✅ Tambahkan `id_store`
            "store_name": responseData['data']['store_name'],
            "store_address": responseData['data']['store_address'],
            "store_phone": responseData['data']['store_phone'],
            "total_sales": double.tryParse(
                    responseData['data']['total_sales'].toString()) ??
                0.0,
          };
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
