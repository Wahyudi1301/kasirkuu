import 'package:flutter/material.dart';
import '../../navigation/app_navigation.dart';

class ProfitPage extends StatelessWidget {
  final String phoneNumber;
  final int idStore;

  const ProfitPage({required this.phoneNumber, required this.idStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laba Rugi")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showProfitDialog(context);
          },
          child: const Text("Lihat Pengeluaran & Pemasukan"),
        ),
      ),
    );
  }

  /// **Menampilkan Modal Bottom Sheet**
  void _showProfitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pengeluaran dan Pemasukan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMenuItem(context, Icons.money_off, "Pengeluaran", () {
                    AppNavigation.navigateToPengeluaran(
                        context, phoneNumber, idStore);
                  }),
                  _buildMenuItem(context, Icons.attach_money, "Pemasukan", () {
                    AppNavigation.navigateToPemasukan(
                        context, phoneNumber, idStore);
                  }),
                  _buildMenuItem(context, Icons.history, "Histori", () {
                    AppNavigation.navigateToHistori(
                        context, phoneNumber, idStore);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// **Membangun Menu Item**
  Widget _buildMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.purple),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
