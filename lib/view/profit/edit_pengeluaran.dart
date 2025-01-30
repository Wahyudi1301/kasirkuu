import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';

class EditPengeluaranPage extends StatefulWidget {
  final LabaRugiData transaction;

  const EditPengeluaranPage({required this.transaction});

  @override
  _EditPengeluaranPageState createState() => _EditPengeluaranPageState();
}

class _EditPengeluaranPageState extends State<EditPengeluaranPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  String? _selectedNameTransaction;

  // **Data kategori pengeluaran**
  final List<String> pengeluaranOptions = [
    "Pembelian Bahan Baku",
    "Gaji Karyawan",
    "Biaya Sewa",
    "Biaya Listrik & Air",
    "Perawatan dan Perbaikan",
    "Marketing dan Iklan",
    "Transportasi dan Logistik",
    "Pembelian Peralatan"
  ];

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.transaction.description);

    // Pastikan kategori yang ada di API cocok dengan daftar yang ada
    if (pengeluaranOptions.contains(widget.transaction.nameTransaction)) {
      _selectedNameTransaction = widget.transaction.nameTransaction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pengeluaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kategori Pengeluaran",
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedNameTransaction,
              hint: const Text("Pilih jenis pengeluaran"),
              items: pengeluaranOptions
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
              decoration: const InputDecoration(
                  hintText: "Masukkan jumlah pengeluaran"),
            ),
            const SizedBox(height: 20),
            const Text("Deskripsi (Opsional)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Masukkan deskripsi pengeluaran"),
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

    final updatedTransaction = LabaRugiData(
      id: widget.transaction.id,
      phoneNumber: widget.transaction.phoneNumber,
      idStore: widget.transaction.idStore,
      transactionType: "pengeluaran",
      nameTransaction: _selectedNameTransaction!,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      date: widget.transaction.date,
      nameUsers: '',
    );

    bool success = await _presenter.updateTransaction(updatedTransaction);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengeluaran berhasil diperbarui!")),
      );
      Navigator.pop(context, true);
    }
  }
}
