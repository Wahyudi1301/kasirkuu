import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: const Center(
        child: Text('Halaman Tambah Produk', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
