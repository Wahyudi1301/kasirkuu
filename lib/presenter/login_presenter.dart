import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_data.dart';

class LoginPresenter {
  final String apiUrl =
      'http://localhost/kasirku/app/login.php'; // Ganti dengan URL API Anda

  Future<String?> login(LoginData data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': data.phoneNumber,
          'password': data.password,
        }),
      );

      print("Response Body: ${response.body}"); // Debug response dari API

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return null; // Login berhasil
        } else {
          return responseData['message'] ?? 'Login gagal!';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }
}
