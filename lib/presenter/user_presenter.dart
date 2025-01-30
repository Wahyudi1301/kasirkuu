import 'dart:convert';
import 'package:http/http.dart' as http;

class UserPresenter {
  final String apiUrl =
      'http://localhost/kasirku/app/users.php'; // Endpoint API

  // Mengambil daftar pengguna
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

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
      print('Error: $e');
      return [];
    }
  }

  // Menambahkan pengguna baru
  Future<bool> addUser({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String status,
    required String password,
    required String loggedInPhone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email,
          'address': address,
          'status': status,
          'password': password,
          'logged_in_phone': loggedInPhone,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return true;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Mengupdate pengguna
  Future<bool> updateUser(Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost/kasirku/app/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return true;
        } else {
          print("Error: ${responseData['message']}");
          return false;
        }
      } else {
        print("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  // Menghapus pengguna
  Future<bool> deleteUser(String phone) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl?phone=$phone'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          return true;
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
