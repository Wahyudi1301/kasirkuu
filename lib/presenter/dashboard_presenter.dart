import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPresenter {
  final String apiUrl =
      'http://localhost/kasirku/app/dashboard.php'; // Ganti dengan URL API Anda

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
          return responseData['data'];
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