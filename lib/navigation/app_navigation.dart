import 'package:flutter/material.dart';
import '../view/transaksi/transaction_page.dart';
import '../view/transaksi/riwayat_transaksi.dart';
import '../view/profit/pengeluaran_page.dart';
import '../view/profit/pemasukan_page.dart';
import '../view/profit/histori_page.dart';
import '../view/staff/add_staff.dart';
import '../view/produk/add_product.dart';
import '../view/dashboard.dart';
import '../view/stok/stok_page.dart'; // ✅ Import halaman Kelola Stok

class AppNavigation {
  // 🔹 Navigasi ke halaman transaksi
  static void navigateToTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionPage()),
    );
  }

  // 🔹 Navigasi ke halaman riwayat transaksi (dengan nomor telepon)
  static void navigateToRiwayatTransaksi(
      BuildContext context, String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiwayatTransaksiPage(phoneNumber: phoneNumber),
      ),
    );
  }

  // 🔹 Navigasi ke halaman Pengeluaran (dengan nomor telepon dan id store)
  static void navigateToPengeluaran(
      BuildContext context, String phoneNumber, int idStore) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PengeluaranPage(phoneNumber: phoneNumber, idStore: idStore),
      ),
    );
  }

  // 🔹 Navigasi ke halaman Pemasukan (dengan nomor telepon dan id store)
  static void navigateToPemasukan(
      BuildContext context, String phoneNumber, int idStore) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PemasukanPage(phoneNumber: phoneNumber, idStore: idStore),
      ),
    );
  }

  // 🔹 Navigasi ke halaman Histori Keuangan (dengan nomor telepon dan id store)
  static void navigateToHistori(
      BuildContext context, String phoneNumber, int idStore) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoriPage(idStore: idStore),
      ),
    );
  }

  // 🔹 Navigasi ke halaman Tambah Staff
  static void navigateToAddStaff(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStaffPage()),
    );
  }

  // 🔹 Navigasi ke halaman Tambah Produk
  static void navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }

  // 🔹 Navigasi ke halaman Kelola Stok
  static void navigateToStock(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const StockPage()), // ✅ Arahkan ke StockPage
    );
  }

  // 🔹 Navigasi ke Dashboard dengan menghapus semua halaman sebelumnya
  static void navigateToDashboard(BuildContext context, String phoneNumber) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(phoneNumber: phoneNumber),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
