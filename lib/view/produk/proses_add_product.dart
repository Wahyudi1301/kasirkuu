import 'package:flutter/material.dart';
import '../../presenter/product_presenter.dart';
import '../../model/product_data.dart';

class ProsesAddProductPage extends StatefulWidget {
  const ProsesAddProductPage({super.key});

  @override
  _ProsesAddProductPageState createState() => _ProsesAddProductPageState();
}

class _ProsesAddProductPageState extends State<ProsesAddProductPage> {
  final ProductPresenter _presenter = ProductPresenter();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();

  int? _selectedCategory;
  int? _selectedUnit;
  List<Category> _categories = [];
  List<Unit> _units = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    final categoriesData = await _presenter.fetchCategories();
    final unitsData = await _presenter.fetchUnits();

    setState(() {
      _categories = categoriesData;
      _units = unitsData;
      if (_categories.isNotEmpty) _selectedCategory = _categories.first.id;
      if (_units.isNotEmpty) _selectedUnit = _units.first.id;
    });
  }

  Future<void> _submitProduct() async {
    if (_nameController.text.isEmpty ||
        _deskripsiController.text.isEmpty ||
        _hargaBeliController.text.isEmpty ||
        _hargaJualController.text.isEmpty ||
        _stokController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedUnit == null ||
        _imgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final productData = {
      "name_product": _nameController.text,
      "id_kategori": _selectedCategory.toString(),
      "deskripsi": _deskripsiController.text,
      "harga_beli": _hargaBeliController.text,
      "harga_jual": _hargaJualController.text,
      "stok": _stokController.text,
      "id_unit": _selectedUnit.toString(),
      "img": _imgController.text,
    };

    bool success = await _presenter.addProduct(productData);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan produk.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Produk')),
              TextField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(labelText: 'Deskripsi')),
              TextField(
                controller: _hargaBeliController,
                decoration: const InputDecoration(labelText: 'Harga Beli'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _hargaJualController,
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _stokController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Kategori',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  // Perbaikan di sini
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Unit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                value: _selectedUnit,
                items: _units.map((unit) {
                  // Perbaikan di sini
                  return DropdownMenuItem<int>(
                    value: unit.id,
                    child: Text(unit.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedUnit = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: 'Gambar URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitProduct,
                  child: const Text('Tambahkan Produk')),
            ],
          ),
        ),
      ),
    );
  }
}
