import 'package:flutter/material.dart';
import '../presenter/user_presenter.dart';

class AddStaffProcessPage extends StatefulWidget {
  const AddStaffProcessPage({super.key});

  @override
  _AddStaffProcessPageState createState() => _AddStaffProcessPageState();
}

class _AddStaffProcessPageState extends State<AddStaffProcessPage> {
  final UserPresenter _presenter = UserPresenter();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _addStaff() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final image = _imageController.text.trim();

    if (name.isEmpty || phone.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final success = await _presenter.addUser(name, phone, image);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff berhasil ditambahkan!')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan staff.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proses Tambah Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Staff'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStaff,
              child: const Text('Tambahkan Staff'),
            ),
          ],
        ),
      ),
    );
  }
}