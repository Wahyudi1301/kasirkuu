import 'package:flutter/material.dart';
import '../view/transaction_page.dart'; // Buat halaman ini
import '../view/history_page.dart'; // Buat halaman ini
import '../view/profit_page.dart'; // Buat halaman ini
import '../view/add_staff_page.dart'; // Buat halaman ini
import '../view/add_product_page.dart'; // Buat halaman ini

class AppNavigation {
  static void navigateToTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionPage()),
    );
  }

  static void navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    );
  }

  static void navigateToProfit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfitPage()),
    );
  }

  static void navigateToAddStaff(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStaffPage()),
    );
  }

  static void navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductPage()),
    );
  }
}
