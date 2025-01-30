import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';

class EditPemasukanPage extends StatefulWidget {
  final LabaRugiData transaction;

  const EditPemasukanPage({required this.transaction});

  @override
  _EditPemasukanPageState createState() => _EditPemasukanPageState();
}

class _EditPemasukanPageState extends State<EditPemasukanPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  String? _selectedNameTransaction;

  final List<String> pemasukanOptions = [
    "Penjualan Produk",
    "Pendanaan Investor",
    "Pinjaman Bisnis",
    "Keuntungan Saham",
    "Pengembalian Dana"
  ];

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.transaction.description);

    // ✅ Pastikan name_transaction dari API ada dalam daftar, jika tidak, tambahkan
    if (!pemasukanOptions.contains(widget.transaction.nameTransaction)) {
      pemasukanOptions.add(widget.transaction.nameTransaction);
    }

    _selectedNameTransaction = widget.transaction.nameTransaction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pemasukan")),
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
              onPressed: _updateTransaction,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTransaction() async {
    if (_selectedNameTransaction == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Harap pilih kategori dan masukkan jumlah.")),
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

    final updatedTransaction = LabaRugiData(
      id: widget.transaction.id,
      phoneNumber: widget.transaction.phoneNumber,
      idStore: widget.transaction.idStore,
      transactionType: "pemasukan",
      nameTransaction: _selectedNameTransaction!,
      amount: amount,
      description: _descriptionController.text,
      date: widget.transaction.date,
      nameUsers: widget.transaction.nameUsers,
    );

    bool success = await _presenter.updateTransaction(updatedTransaction);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pemasukan berhasil diperbarui!")),
      );
      Navigator.pop(context, true); // ✅ Refresh data setelah edit
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui pemasukan.")),
      );
    }
  }
}
