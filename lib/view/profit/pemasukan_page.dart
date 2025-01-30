import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';
import 'add_pemasukan.dart';
import 'edit_pemasukan.dart';

class PemasukanPage extends StatefulWidget {
  final String phoneNumber;
  final int idStore;

  const PemasukanPage({required this.phoneNumber, required this.idStore});

  @override
  _PemasukanPageState createState() => _PemasukanPageState();
}

class _PemasukanPageState extends State<PemasukanPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  List<LabaRugiData> _transactions = [];
  bool _isLoading = true;
  double totalPemasukan = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  /// **Mengambil transaksi pemasukan berdasarkan tanggal**
  void _fetchTransactions() async {
    try {
      setState(() => _isLoading = true);

      String dateFilter = _selectedDate == null
          ? DateTime.now().toIso8601String().split("T")[0] // Default: Hari ini
          : _selectedDate!.toIso8601String().split("T")[0];

      List<LabaRugiData> transactions = await _presenter.getTransactionsByDate(
          "pemasukan", widget.phoneNumber, widget.idStore, dateFilter);

      Map<String, double> totals =
          await _presenter.getTotalsByDate(widget.idStore, dateFilter);

      setState(() {
        _transactions = transactions;
        totalPemasukan = totals["total_pemasukan"] ?? 0.0; // Hindari null
        _isLoading = false;
      });
    } catch (e) {
      print("🔴 Error fetching transactions: $e");
      setState(() => _isLoading = false);
    }
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

  /// **Navigasi ke halaman tambah pemasukan**
  void _addTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPemasukanPage(
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

  /// **Navigasi ke halaman edit pemasukan**
  void _editTransaction(LabaRugiData transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPemasukanPage(transaction: transaction),
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
        title: const Text("Pemasukan"),
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
                  "Total Pemasukan: Rp ${totalPemasukan.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: _transactions.isEmpty
                      ? const Center(child: Text("Tidak ada pemasukan"))
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
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Text(
                                    transaction.nameUsers.isNotEmpty
                                        ? transaction.nameUsers[0].toUpperCase()
                                        : "?",
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
