import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';

class AddPengeluaranPage extends StatefulWidget {
  final String phoneNumber;
  final int idStore;

  const AddPengeluaranPage({required this.phoneNumber, required this.idStore});

  @override
  _AddPengeluaranPageState createState() => _AddPengeluaranPageState();
}

class _AddPengeluaranPageState extends State<AddPengeluaranPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedNameTransaction;

  // **Data kategori pengeluaran yang berbeda dari pemasukan**
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pengeluaran")),
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
              onPressed: _submitTransaction,
              child: const Text("Simpan Pengeluaran"),
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
                Text("Harap pilih kategori pengeluaran dan masukkan jumlah.")),
      );
      return;
    }

    final transaction = LabaRugiData(
      id: 0,
      phoneNumber: widget.phoneNumber,
      idStore: widget.idStore,
      transactionType: "pengeluaran",
      nameTransaction: _selectedNameTransaction!,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      date: DateTime.now().toIso8601String().split("T")[0],
      nameUsers: '',
    );

    bool success = await _presenter.addTransaction(transaction);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengeluaran berhasil ditambahkan!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan pengeluaran.")),
      );
    }
  }
}
