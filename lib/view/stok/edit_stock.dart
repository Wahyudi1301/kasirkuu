import 'package:flutter/material.dart';
import '../../presenter/stok_presenter.dart';
import '../../model/stock_data.dart';

class EditStockPage extends StatefulWidget {
  final Stock stock;

  const EditStockPage({required this.stock});

  @override
  _EditStockPageState createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final StockPresenter _presenter = StockPresenter();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stockController.text = widget.stock.stok.toString();
  }

  void _updateStock() async {
    if (_stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok tidak boleh kosong.")),
      );
      return;
    }

    int newStock = int.parse(_stockController.text);
    bool success =
        await _presenter.updateStock(widget.stock.idProduct, newStock);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok berhasil diperbarui!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui stok.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Stok")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nama Produk",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.stock.nameProduct,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text("Stok Baru",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Masukkan jumlah stok baru"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStock,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
