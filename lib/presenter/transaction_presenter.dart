import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_item.dart';
import '../presenter/dashboard_presenter.dart'; // ✅ Import DashboardPresenter

class TransactionPresenter {
  final String apiUrl = 'http://localhost/kasirku/app/transaksi.php';
  final DashboardPresenter dashboardPresenter; // ✅ Tambahkan DashboardPresenter
  List<CartItem> cart = [];

  TransactionPresenter(this.dashboardPresenter); // ✅ Gunakan di constructor

  /// **Menambahkan produk ke pesanan**
  void addToCart(CartItem item) {
    var existingItem = cart.firstWhere(
      (cartItem) => cartItem.id == item.id,
      orElse: () => CartItem(id: -1, name: '', price: 0, quantity: 0),
    );

    if (existingItem.id != -1) {
      existingItem.quantity += 1;
    } else {
      cart.add(item);
    }
  }

  /// **Menghitung total harga**
  double getTotal() {
    return cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// **Mengirim transaksi ke server berdasarkan user yang login**
  Future<bool> submitTransaction(double uangDiterima) async {
    if (cart.isEmpty) return false;

    var userData = await dashboardPresenter.fetchDashboardData("081234567890");
    if (userData == null ||
        !userData.containsKey("user_phone_number") ||
        !userData.containsKey("id_store")) {
      print("❌ Error: Gagal mendapatkan data user dari dashboard");
      return false;
    }

    String phoneNumber = userData["user_phone_number"];
    int idStore = int.tryParse(userData["id_store"].toString()) ??
        0; // ✅ Konversi String ke int

    final transactionData = {
      "phone_number": phoneNumber,
      "id_store": idStore, // ✅ Kirim id_store ke server
      "total_harga": getTotal().toString(),
      "uang_diterima": uangDiterima.toString(),
      "items": cart
          .map((item) => {
                "id_product": item.id,
                "jumlah": item.quantity,
                "total_price": (item.quantity * item.price).toString(),
                "harga_saat_transaksi": item.price
                    .toString() // ✅ Pastikan harga saat transaksi dikirim
              })
          .toList(),
    };

    print("🟢 Data yang dikirim ke server: ${jsonEncode(transactionData)}");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transactionData),
      );

      print("🔵 Respon dari server: ${response.body}");

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        cart.clear();
        return true;
      } else {
        print("⚠️ Transaksi gagal: ${responseData['message']}");
        return false;
      }
    } catch (e) {
      print("🔴 Error saat mengirim transaksi: $e");
      return false;
    }
  }
}
