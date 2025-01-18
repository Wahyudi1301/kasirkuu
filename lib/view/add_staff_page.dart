import 'package:flutter/material.dart';

class AddStaffPage extends StatelessWidget {
  const AddStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Staff')),
      body: const Center(
        child: Text('Halaman Tambah Staff', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
