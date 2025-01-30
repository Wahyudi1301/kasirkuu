import 'package:flutter/material.dart';
import '../../../../presenter/riwayat_transaksi_presenter.dart';
import '../../../../presenter/dashboard_presenter.dart';
import 'detail_transaksi.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  final String phoneNumber;

  const RiwayatTransaksiPage({super.key, required this.phoneNumber});

  @override
  _RiwayatTransaksiPageState createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  final RiwayatTransaksiPresenter _presenter =
      RiwayatTransaksiPresenter(DashboardPresenter());

  List<Map<String, dynamic>> _riwayatTransaksi = [];
  bool _isLoading = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchRiwayatTransaksi();
  }

  /// **Mengambil riwayat transaksi berdasarkan id_store**
  void _fetchRiwayatTransaksi() async {
    final data = await _presenter.fetchRiwayatTransaksi(widget.phoneNumber);
    setState(() {
      _riwayatTransaksi = data;
      _isLoading = false;
    });
  }

  /// **Navigasi ke Detail Transaksi**
  void _navigateToDetail(String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTransaksiPage(phoneNumber: phoneNumber),
      ),
    );
  }

  /// **Menampilkan Date Picker dan Memfilter Data Berdasarkan Tanggal**
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchRiwayatTransaksi(); // Fetch data dengan filter tanggal
    }
  }

  /// **Memfilter Data Berdasarkan Tanggal yang Dipilih**
  List<Map<String, dynamic>> _filterTransaksiByDate() {
    if (_selectedDate == null) {
      return _riwayatTransaksi;
    } else {
      return _riwayatTransaksi.where((transaksi) {
        DateTime transaksiDate = DateTime.parse(transaksi['tanggal']);
        return transaksiDate.year == _selectedDate!.year &&
            transaksiDate.month == _selectedDate!.month &&
            transaksiDate.day == _selectedDate!.day;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransaksi = _filterTransaksiByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _selectedDate == null
                        ? "Tanggal: Hari Ini"
                        : "Tanggal: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: filteredTransaksi.isEmpty
                      ? const Center(child: Text("Tidak ada riwayat transaksi"))
                      : ListView.builder(
                          itemCount: filteredTransaksi.length,
                          itemBuilder: (context, index) {
                            final transaksi = filteredTransaksi[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                title: Text(
                                    "Kode: ${transaksi['kode_transaksi']}"),
                                subtitle: Text(
                                    "Total: Rp. ${transaksi['total_harga']}"),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () =>
                                    _navigateToDetail(widget.phoneNumber),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
