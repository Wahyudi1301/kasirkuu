import 'package:flutter/material.dart';
import '../../presenter/user_presenter.dart';

class AddStaffProcessPage extends StatefulWidget {
  const AddStaffProcessPage({super.key});

  @override
  _AddStaffProcessPageState createState() => _AddStaffProcessPageState();
}

class _AddStaffProcessPageState extends State<AddStaffProcessPage> {
  final UserPresenter _presenter = UserPresenter();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String loggedInPhone = '081234567890';

  String? _selectedStatus;
  final List<String> _statusOptions = ['staff', 'admin'];

  Future<void> _addStaff() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final status = _selectedStatus;
    final password = _passwordController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        status == null ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final success = await _presenter.addUser(
      name: name,
      phone: phone,
      email: email,
      address: address,
      status: status,
      password: password,
      loggedInPhone: loggedInPhone,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff berhasil ditambahkan!')),
      );
      Navigator.pop(context);
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
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Staff')),
            TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon')),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Alamat')),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              hint: const Text('Pilih Status'),
              items: _statusOptions
                  .map((String status) =>
                      DropdownMenuItem(value: status, child: Text(status)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedStatus = value),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _addStaff, child: const Text('Tambahkan Staff')),
          ],
        ),
      ),
    );
  }
}
