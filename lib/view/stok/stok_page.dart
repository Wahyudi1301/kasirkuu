import 'package:flutter/material.dart';
import '../../presenter/stok_presenter.dart';
import '../../model/stock_data.dart';
import 'edit_stock.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final StockPresenter _presenter = StockPresenter();
  List<Stock> _stocks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStock();
  }

  Future<void> _fetchStock() async {
    List<Stock> stocks = await _presenter.getStock();
    setState(() {
      _stocks = stocks;
      _isLoading = false;
    });
  }

  void _editStock(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStockPage(stock: stock),
      ),
    ).then((result) {
      if (result == true) {
        _fetchStock(); // Refresh data setelah edit stok
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Stok")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _stocks.length,
              itemBuilder: (context, index) {
                final stock = _stocks[index];
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(stock.nameProduct),
                    subtitle: Text("Stok: ${stock.stok}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editStock(stock),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
