import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';

class AddPemasukanPage extends StatefulWidget {
  final String phoneNumber;
  final int idStore;

  const AddPemasukanPage({required this.phoneNumber, required this.idStore});

  @override
  _AddPemasukanPageState createState() => _AddPemasukanPageState();
}

class _AddPemasukanPageState extends State<AddPemasukanPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedNameTransaction;

  final List<String> pemasukanOptions = [
    "Penjualan Produk",
    "Pendanaan Investor",
    "Pinjaman Bisnis",
    "Keuntungan Saham",
    "Pengembalian Dana"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pemasukan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kategori Pemasukan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedNameTransaction,
              hint: const Text("Pilih jenis pemasukan"),
              items: pemasukanOptions
                  .map((name) =>
                      DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedNameTransaction = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Jumlah (Rp)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Masukkan jumlah pemasukan"),
            ),
            const SizedBox(height: 20),
            const Text("Deskripsi (Opsional)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Masukkan deskripsi pemasukan"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: const Text("Simpan Pemasukan"),
            ),
          ],
        ),
      ),
    );
  }

  void _submitTransaction() async {
    if (_selectedNameTransaction == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Harap pilih kategori pemasukan dan masukkan jumlah.")),
      );
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah pemasukan tidak valid.")),
      );
      return;
    }

    final transaction = LabaRugiData(
      id: 0, // Auto-increment di database
      phoneNumber: widget.phoneNumber,
      idStore: widget.idStore,
      transactionType: "pemasukan",
      nameTransaction: _selectedNameTransaction!,
      amount: amount,
      description: _descriptionController.text,
      date: DateTime.now().toIso8601String().split("T")[0], // Format YYYY-MM-DD
      nameUsers: "Tidak Diketahui", // Bisa diganti jika API membutuhkan
    );

    try {
      bool success = await _presenter.addTransaction(transaction);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pemasukan berhasil ditambahkan!")),
        );
        Navigator.pop(context, true); // ✅ Refresh data setelah transaksi sukses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan pemasukan.")),
        );
      }
    } catch (e) {
      print("🔴 Error Tambah Transaksi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan, coba lagi.")),
      );
    }
  }
}
