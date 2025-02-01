import 'package:flutter/material.dart';
import '../../../model/cart_item.dart';
import '../../../model/product_data.dart';
import '../../../presenter/product_presenter.dart';
import '../../../presenter/transaction_presenter.dart';
import '../../../presenter/dashboard_presenter.dart';
import 'pesanan_page.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TransactionPresenter _transactionPresenter = TransactionPresenter(
      DashboardPresenter()); // ✅ Gunakan DashboardPresenter
  final ProductPresenter _productPresenter = ProductPresenter();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    List<Product> products = await _productPresenter.fetchProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  void _selectProduct(Product product) {
    CartItem cartItem = CartItem(
      id: product.idProduct,
      name: product.nameProduct,
      price: product.hargaJual.toDouble(),
      quantity: 1,
    );

    setState(() {
      _transactionPresenter.addToCart(cartItem);
    });

    // Navigasi ke halaman pesanan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PesananPage(
          cart: _transactionPresenter.cart,
          presenter: _transactionPresenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Produk")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      product.nameProduct.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(product.nameProduct),
                  subtitle: Text("Rp. ${product.hargaJual}"),
                  onTap: () => _selectProduct(product),
                );
              },
            ),
    );
  }
}
