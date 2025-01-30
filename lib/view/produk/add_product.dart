import 'package:flutter/material.dart';
import '../../presenter/product_presenter.dart';
import '../../model/product_data.dart';
import 'proses_add_product.dart';
import 'edit_product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductPresenter _presenter = ProductPresenter();
  List<Product> _productList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    setState(() => _isLoading = true);
    final products = await _presenter.fetchProducts();

    print("Jumlah Produk Ditemukan: ${products.length}");

    setState(() {
      _productList = products;
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(int idProduct) async {
    if (await _presenter.deleteProduct(idProduct)) {
      _fetchProductData();
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(" ");
    String initials = "";

    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0]; // Huruf pertama kata pertama
      if (nameParts.length > 1) {
        initials += nameParts[1][0]; // Huruf pertama kata kedua
      }
    }
    return initials.toUpperCase(); // Pastikan huruf kapital
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _productList.isEmpty
              ? const Center(child: Text('Belum ada data produk.'))
              : ListView.builder(
                  itemCount: _productList.length,
                  itemBuilder: (context, index) {
                    final product = _productList[index];
                    bool isImageAvailable = product.img.isNotEmpty;

                    return ListTile(
                      leading: isImageAvailable
                          ? ClipOval(
                              child: Image.network(
                                'http://localhost/kasirku/img/${product.img}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    radius: 25,
                                    child: Text(
                                      _getInitials(product.nameProduct),
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.purple,
                              radius: 25,
                              child: Text(
                                _getInitials(product.nameProduct),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                      title: Text(product.nameProduct),
                      subtitle: Text(
                          'Stok: ${product.stok}, Harga: ${product.hargaJual}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductPage(product: product),
                                ),
                              ).then((_) => _fetchProductData());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product.idProduct),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProsesAddProductPage()),
        ).then((_) => _fetchProductData()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
