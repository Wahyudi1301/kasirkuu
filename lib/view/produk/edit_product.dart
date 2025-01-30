import 'package:flutter/material.dart';
import '../../model/product_data.dart';
import '../../presenter/product_presenter.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductPresenter _presenter = ProductPresenter();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  int? _selectedCategory;
  int? _selectedUnit;
  List<Category> _categories = [];
  List<Unit> _units = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchDropdownData();
  }

  void _initializeFields() {
    _nameController.text = widget.product.nameProduct;
    _descriptionController.text = widget.product.deskripsi.toString();
    _purchasePriceController.text = widget.product.hargaBeli.toString();
    _sellingPriceController.text = widget.product.hargaJual.toString();
    _stockController.text = widget.product.stok.toString();
    _imageController.text = widget.product.img.toString();
    _selectedCategory = widget.product.idKategori;
    _selectedUnit = widget.product.idUnit;
  }

  Future<void> _fetchDropdownData() async {
    try {
      final categories = await _presenter.fetchCategories();
      final units = await _presenter.fetchUnits();

      setState(() {
        _categories = categories;
        _units = units;

        // Pastikan nilai yang dipilih ada di daftar, jika tidak ada, set null
        if (!_categories.any((c) => c.id == _selectedCategory)) {
          _selectedCategory = null;
        }
        if (!_units.any((u) => u.id == _selectedUnit)) {
          _selectedUnit = null;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data dropdown: $e')),
      );
    }
  }

  Future<void> _updateProduct() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _purchasePriceController.text.isEmpty ||
        _sellingPriceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final updatedProduct = {
      'id_product': widget.product.idProduct.toString(),
      'name_product': _nameController.text.trim(),
      'deskripsi': _descriptionController.text.trim(),
      'harga_beli': _purchasePriceController.text.trim(),
      'harga_jual': _sellingPriceController.text.trim(),
      'stok': _stockController.text.trim(),
      'img': _imageController.text.trim(),
      'id_kategori': _selectedCategory.toString(),
      'id_unit': _selectedUnit.toString(),
    };

    final success = await _presenter.updateProduct(updatedProduct);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui produk.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: _purchasePriceController,
                decoration: const InputDecoration(labelText: 'Harga Beli'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
              ),

              const SizedBox(height: 16),

              /// **Dropdown Kategori**
              const Text('Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                value: (_categories.any((c) => c.id == _selectedCategory))
                    ? _selectedCategory
                    : null,
                hint: const Text('Pilih Kategori'),
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              /// **Dropdown Unit**
              const Text('Unit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                value: (_units.any((u) => u.id == _selectedUnit))
                    ? _selectedUnit
                    : null,
                hint: const Text('Pilih Unit'),
                items: _units.map((unit) {
                  return DropdownMenuItem<int>(
                    value: unit.id,
                    child: Text(unit.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),

              /// **Tombol Update**
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text('Update Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
