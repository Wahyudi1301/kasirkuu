import 'package:flutter/material.dart';
import '../../presenter/user_presenter.dart';

class EditStaffPage extends StatefulWidget {
  final Map<String, dynamic> staffData;

  const EditStaffPage({super.key, required this.staffData});

  @override
  _EditStaffPageState createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  final UserPresenter _presenter = UserPresenter();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedStatus;
  final List<String> _statusOptions = ['admin', 'staff'];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.staffData['name'] ?? '';
    _phoneController.text = widget.staffData['phone'] ?? '';
    _emailController.text = widget.staffData['email'] ?? '';
    _addressController.text = widget.staffData['address'] ?? '';
    _selectedStatus = widget.staffData['status'] ?? 'Staff'; // Default status
  }

  Future<void> _updateStaff() async {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih status!')),
      );
      return;
    }

    final updatedData = {
      'phone': widget.staffData['phone'],
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim(),
      'status': _selectedStatus,
    };

    final bool success = await _presenter.updateUser(updatedData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui staff.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Staff'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Alamat'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              value: _selectedStatus != null &&
                      _statusOptions.contains(_selectedStatus)
                  ? _selectedStatus
                  : null,
              hint: const Text('Pilih Status'),
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStaff,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Staff'),
            ),
          ],
        ),
      ),
    );
  }
}
