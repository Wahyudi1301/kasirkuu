import 'package:flutter/material.dart';
import '../model/register_data.dart';
import '../presenter/register_presenter.dart';
import '../navigation/register_navigation.dart'; // Tambahkan import navigasi

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final RegisterPresenter _presenter = RegisterPresenter();
  final RegisterData _registerData = RegisterData();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // Untuk toggle password visibility

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses pendaftaran menggunakan presenter
      final result = await _presenter.register(_registerData);

      setState(() {
        _isLoading = false;
      });

      if (result == null) {
        // Navigasi ke halaman login jika berhasil
        print("Navigasi ke halaman login berhasil dipanggil");
        RegisterNavigation.navigateToLogin(context);
      } else {
        // Tampilkan error jika gagal
        print("Pendaftaran gagal: $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input nama toko
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Toko'),
                onChanged: (value) => _registerData.nameStore = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Toko harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input format uang
              TextFormField(
                decoration: const InputDecoration(labelText: 'Format Uang'),
                onChanged: (value) => _registerData.formatCurrency = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Format Uang harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input jenis usaha
              TextFormField(
                decoration: const InputDecoration(labelText: 'Jenis Usaha'),
                onChanged: (value) => _registerData.businessType = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis Usaha harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input alamat toko
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat Toko'),
                onChanged: (value) => _registerData.addressStore = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Toko harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input email toko
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Toko'),
                onChanged: (value) => _registerData.emailStore = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Toko harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input nomor telepon toko
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nomor Telepon Toko'),
                onChanged: (value) => _registerData.phoneStore = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon Toko harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input nama admin
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Admin'),
                onChanged: (value) => _registerData.fullName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Admin harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input nomor telepon admin
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nomor Telepon Admin'),
                onChanged: (value) => _registerData.phoneNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon Admin harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input password admin dengan toggle visibility
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password Admin',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                onChanged: (value) => _registerData.password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password Admin harus diisi';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input email admin
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Admin'),
                onChanged: (value) => _registerData.email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email Admin harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Input alamat admin
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat Admin'),
                onChanged: (value) => _registerData.address = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Admin harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Tombol Daftar
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Daftar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
