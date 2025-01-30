import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/laba_rugi_data.dart';

class LabaRugiPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/laba_rugi.php';

  /// **Mengambil daftar transaksi berdasarkan jenis transaksi (pemasukan/pengeluaran)**
  Future<List<LabaRugiData>> getTransactionsByDate(
      String type, String phoneNumber, int idStore, String date) async {
    try {
      // 🔵 Debugging: Cek data sebelum dikirim ke API
      print("🔵 Mengirim request ke API ($type)");
      print("📌 phone_number: $phoneNumber");
      print("📌 id_store: $idStore");
      print("📌 date: $date");

      final response = await http.post(
        Uri.parse('$apiUrl?getTransactionsByDate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'transaction_type': type,
          'phone_number': phoneNumber,
          'id_store': idStore.toString(), // 🔹 Pastikan dikirim sebagai String
          'date': date,
        }),
      );

      print("🔵 Respon Ambil Transaksi ($type): ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          List<LabaRugiData> transactions = (responseData['data'] as List)
              .map((item) => LabaRugiData.fromMap(item))
              .toList();
          return transactions;
        } else {
          print("⚠ API Mengembalikan Error: ${responseData['message']}");
          return [];
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error Ambil Transaksi ($type): $e');
      return [];
    }
  }

  /// **Mengambil semua transaksi berdasarkan `id_store` dan `date`**
  Future<List<LabaRugiData>> getAllTransactionsByStore(
      int idStore, String date) async {
    try {
      // 🔵 Debugging: Cek data sebelum dikirim ke API
      print("🔵 Mengambil semua transaksi di Store");
      print("📌 id_store: $idStore");
      print("📌 date: $date");

      final response = await http.post(
        Uri.parse('$apiUrl?getAllTransactionsByStore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_store': idStore.toString(),
          'date': date
        }), // 🔹 Pastikan dikirim sebagai String
      );

      print("🔵 Respon Ambil Semua Transaksi di Store: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          List<LabaRugiData> transactions = (responseData['data'] as List)
              .map((item) => LabaRugiData.fromMap(item))
              .toList();
          return transactions;
        } else {
          print("⚠ API Mengembalikan Error: ${responseData['message']}");
          return [];
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error Ambil Transaksi Store: $e');
      return [];
    }
  }

  /// **Mengambil total pemasukan, pengeluaran, dan profit berdasarkan tanggal**
  Future<Map<String, double>> getTotalsByDate(int idStore, String date) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/kasirku/app/laba_rugi.php?getTotalsByDate"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_store': idStore, 'date': date}),
      );

      print("🔵 Respon Total Keuangan: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return {
            "total_pemasukan":
                double.parse(responseData['total_pemasukan'].toString()),
            "total_pengeluaran":
                double.parse(responseData['total_pengeluaran'].toString()),
            "total_profit":
                double.parse(responseData['total_profit'].toString()),
          };
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error Get Totals: $e');
      return {"total_pemasukan": 0, "total_pengeluaran": 0, "total_profit": 0};
    }
  }

  Future<bool> addTransaction(LabaRugiData transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?addTransaction'), // Endpoint API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': transaction.phoneNumber,
          'id_store': transaction.idStore,
          'transaction_type':
              transaction.transactionType, // "pemasukan" / "pengeluaran"
          'name_transaction': transaction.nameTransaction,
          'amount': transaction.amount,
          'description': transaction.description,
          'date': transaction.date,
        }),
      );

      print("🔵 Respon Tambah Transaksi: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == 'success';
      } else {
        print("⚠ Gagal menambahkan transaksi: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print('🔴 Error Tambah Transaksi: $e');
      return false;
    }
  }

  Future<bool> updateTransaction(LabaRugiData transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?updateTransaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': transaction.id,
          'phone_number': transaction.phoneNumber,
          'id_store': transaction.idStore,
          'transaction_type': transaction.transactionType,
          'name_transaction': transaction.nameTransaction,
          'amount': transaction.amount,
          'description': transaction.description,
          'date': transaction.date,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        return true;
      } else {
        print("⚠ Gagal memperbarui transaksi: ${responseData['message']}");
        return false;
      }
    } catch (e) {
      print('🔴 Error Update Transaksi: $e');
      return false;
    }
  }
}
