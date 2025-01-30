import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';
import 'add_pengeluaran.dart';
import 'edit_pengeluaran.dart';

class PengeluaranPage extends StatefulWidget {
  final String phoneNumber;
  final int idStore;

  const PengeluaranPage({required this.phoneNumber, required this.idStore});

  @override
  _PengeluaranPageState createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  List<LabaRugiData> _transactions = [];
  bool _isLoading = true;
  double totalPengeluaran = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// **Mengambil transaksi pengeluaran berdasarkan tanggal**
  void _fetchTransactions() async {
    setState(() => _isLoading = true);

    String dateFilter = _selectedDate == null
        ? DateTime.now().toIso8601String().split("T")[0]
        : _selectedDate!.toIso8601String().split("T")[0];

    List<LabaRugiData> transactions = await _presenter.getTransactionsByDate(
        "pengeluaran", widget.phoneNumber, widget.idStore, dateFilter);

    Map<String, double> totals =
        await _presenter.getTotalsByDate(widget.idStore, dateFilter);

    setState(() {
      _transactions = transactions;
      totalPengeluaran = totals["total_pengeluaran"] ?? 0.0;
      _isLoading = false;
    });
  }

  /// **Menampilkan Date Picker**
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
      _fetchTransactions();
    }
  }

  /// **Navigasi ke halaman tambah pengeluaran**
  void _addTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPengeluaranPage(
          phoneNumber: widget.phoneNumber,
          idStore: widget.idStore,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _fetchTransactions();
      }
    });
  }

  /// **Navigasi ke halaman edit transaksi**
  void _editTransaction(LabaRugiData transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPengeluaranPage(transaction: transaction),
      ),
    ).then((result) {
      if (result == true) {
        _fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengeluaran"),
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
                Text(
                  "Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: _transactions.isEmpty
                      ? const Center(child: Text("Tidak ada pengeluaran"))
                      : ListView.builder(
                          itemCount: _transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _transactions[index];

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 20,
                                  child: Text(
                                    transaction.nameUsers[0].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                title: Text(transaction.nameTransaction),
                                subtitle: Text(
                                    "Rp ${transaction.amount} - ${transaction.description}\nUser: ${transaction.nameUsers}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _editTransaction(transaction),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
