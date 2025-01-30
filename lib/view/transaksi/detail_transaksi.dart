import 'package:flutter/material.dart';
import '../../../presenter/detail_transaksi_presenter.dart';
import '../../../presenter/dashboard_presenter.dart';
import '../../../view/dashboard.dart';

class DetailTransaksiPage extends StatefulWidget {
  final String phoneNumber;

  const DetailTransaksiPage({super.key, required this.phoneNumber});

  @override
  _DetailTransaksiPageState createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  final DetailTransaksiPresenter _presenter =
      DetailTransaksiPresenter(DashboardPresenter());

  Map<String, dynamic>? _transactionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  void _fetchTransactionData() async {
    final data = await _presenter.fetchLastTransaction(widget.phoneNumber);
    setState(() {
      _transactionData = data;
      _isLoading = false;
    });
  }

  void _printTransaction() {
    // Implementasi fungsi cetak
    print("🖨️ Mencetak transaksi...");
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardPage(phoneNumber: widget.phoneNumber)),
      (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactionData == null
              ? const Center(child: Text("Gagal mengambil data transaksi"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // **Store Information**
                      Text(
                        "${_transactionData!['name_store']}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("${_transactionData!['alamat_store']}"),
                      Text("Telp: ${_transactionData!['phone_number_store']}"),
                      const Divider(),

                      // **Detail Transaksi**
                      Text(
                        "Kode Transaksi: ${_transactionData!['kode_transaksi']}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Tanggal: ${_transactionData!['tanggal']}"),
                      const SizedBox(height: 10),

                      // **Detail Produk**
                      Expanded(
                        child: ListView.builder(
                          itemCount: _transactionData!['items'].length,
                          itemBuilder: (context, index) {
                            final itemD = _transactionData!['items'][index];

                            return ListTile(
                              title: Text(itemD['name_product'] ??
                                  "Nama Produk Tidak Ditemukan"), // ✅ Perbaikan
                              subtitle: Text(
                                  "${itemD['jumlah']} x Rp. ${itemD['harga_saat_transaksi']}"),
                              trailing: Text(
                                  "Rp. ${(int.tryParse(itemD['jumlah'].toString()) ?? 0) * (double.tryParse(itemD['harga_saat_transaksi'].toString()) ?? 0.0)}"),
                            );
                          },
                        ),
                      ),

                      const Divider(),

                      // **Total & Kembalian**
                      Text(
                        "Total: Rp. ${_transactionData!['total_harga']}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Dibayar: Rp. ${_transactionData!['uang_diterima']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Kembalian: Rp. ${_transactionData!['kembalian']}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      const SizedBox(height: 20),

                      // **Tombol Print & Home**
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _printTransaction,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              child: const Text("Print"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _goToHome,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text("Home"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
