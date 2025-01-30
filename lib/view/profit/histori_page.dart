import 'package:flutter/material.dart';
import '../../presenter/laba_rugi_presenter.dart';
import '../../model/laba_rugi_data.dart';

class HistoriPage extends StatefulWidget {
  final int idStore;

  const HistoriPage({required this.idStore});

  @override
  _HistoriPageState createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  final LabaRugiPresenter _presenter = LabaRugiPresenter();
  List<LabaRugiData> _transactions = [];
  bool _isLoading = true;
  double totalPemasukan = 0;
  double totalPengeluaran = 0;
  double totalProfit = 0;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() async {
    setState(() => _isLoading = true);

    String dateFilter = _selectedDate == null
        ? DateTime.now().toIso8601String().split("T")[0]
        : _selectedDate!.toIso8601String().split("T")[0];

    List<LabaRugiData> transactions =
        await _presenter.getAllTransactionsByStore(widget.idStore, dateFilter);

    Map<String, double> totals =
        await _presenter.getTotalsByDate(widget.idStore, dateFilter);

    setState(() {
      _transactions = transactions;
      totalPemasukan = totals["total_pemasukan"]!;
      totalPengeluaran = totals["total_pengeluaran"]!;
      totalProfit = totals["total_profit"]!;
      _isLoading = false;
    });
  }

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

  Widget _buildTotalRow(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("Rp ${amount.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histori Keuangan"),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTotalRow(
                        "Total Pemasukan", totalPemasukan, Colors.green),
                    _buildTotalRow(
                        "Total Pengeluaran", totalPengeluaran, Colors.red),
                    _buildTotalRow("Total Profit", totalProfit, Colors.blue),
                  ],
                ),
                Expanded(
                  child: _transactions.isEmpty
                      ? const Center(child: Text("Tidak ada transaksi"))
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
                                  backgroundColor:
                                      transaction.transactionType == "pemasukan"
                                          ? Colors.green
                                          : Colors.red,
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
