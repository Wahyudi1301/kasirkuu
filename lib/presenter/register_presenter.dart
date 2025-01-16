import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/register_data.dart';

class RegisterPresenter {
  final String apiUrl =
      'http://localhost/kasirku/app/register.php'; // URL API Anda

  Future<String?> register(RegisterData data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'store': {
            'name_store': data.nameStore,
            'format_uang': data.formatCurrency,
            'jenis_usaha': data.businessType,
            'alamat_store': data.addressStore,
            'email_store': data.emailStore,
            'phone_number_store': data.phoneStore,
          },
          'user': {
            'full_name': data.fullName,
            'phone_number': data.phoneNumber,
            'password': data.password,
            'email': data.email,
            'alamat': data.address,
          }
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return 'Register berhasil!';
        } else {
          return responseData['message'] ?? 'Register gagal!';
        }
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }
}
