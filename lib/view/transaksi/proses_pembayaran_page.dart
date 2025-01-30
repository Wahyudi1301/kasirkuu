import 'package:flutter/material.dart';
import '../../../model/cart_item.dart';
import '../../../presenter/transaction_presenter.dart';
import '../../../view/transaksi/detail_transaksi.dart'; // ✅ Import halaman Detail Transaksi

class ProsesPembayaranPage extends StatefulWidget {
  final List<CartItem> cart;
  final TransactionPresenter presenter;

  const ProsesPembayaranPage({
    super.key,
    required this.cart,
    required this.presenter,
  });

  @override
  _ProsesPembayaranPageState createState() => _ProsesPembayaranPageState();
}

class _ProsesPembayaranPageState extends State<ProsesPembayaranPage> {
  final TextEditingController _uangDiterimaController = TextEditingController();
  double _uangDiterima = 0.0;
  double _totalHarga = 0.0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _totalHarga = widget.presenter.getTotal();
  }

  void _hitungKembalian() {
    setState(() {
      _uangDiterima = double.tryParse(_uangDiterimaController.text) ?? 0.0;
    });
  }

  /// **Navigasi ke halaman Detail Transaksi setelah pembayaran berhasil**
  void _submitTransaction() async {
    double uangDiterima = double.tryParse(_uangDiterimaController.text) ?? 0.0;

    if (uangDiterima < _totalHarga) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uang yang diterima kurang")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    bool success = await widget.presenter.submitTransaction(uangDiterima);

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi berhasil!")),
      );

      // ✅ Navigasi ke halaman Detail Transaksi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailTransaksiPage(
            phoneNumber: "081234567890", // ✅ Gunakan nomor user yang login
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi gagal, coba lagi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double kembalian = _uangDiterima - _totalHarga;

    return Scaffold(
      appBar: AppBar(title: const Text("Proses Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("${item.quantity} x Rp. ${item.price}"),
                    trailing: Text("Rp. ${item.quantity * item.price}"),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rp. $_totalHarga",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(),
                  TextField(
                    controller: _uangDiterimaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Uang Yang Diterima",
                    ),
                    onChanged: (value) => _hitungKembalian(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Kembalian",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        kembalian >= 0
                            ? "Rp. $kembalian"
                            : "Kurang Rp. ${-kembalian}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kembalian >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _isProcessing
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitTransaction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                kembalian >= 0 ? Colors.blue : Colors.grey,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("Bayar"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
