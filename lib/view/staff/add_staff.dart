import 'package:flutter/material.dart';
import 'proses_add_staff.dart';
import 'edit_staff.dart';
import '../../presenter/user_presenter.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final UserPresenter _presenter = UserPresenter();
  List<Map<String, dynamic>> _staffList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  Future<void> _fetchStaffData() async {
    setState(() {
      _isLoading = true;
    });

    final data = await _presenter.fetchUsers();
    setState(() {
      _staffList = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteStaff(String phone) async {
    final success = await _presenter.deleteUser(phone);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff berhasil dihapus!')),
      );
      _fetchStaffData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus staff.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Staff')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _staffList.isEmpty
              ? const Center(child: Text('Belum ada data staff.'))
              : ListView.builder(
                  itemCount: _staffList.length,
                  itemBuilder: (context, index) {
                    final staff = _staffList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          staff['image'] ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                      title: Text(staff['name']),
                      subtitle: Text(staff['phone']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditStaffPage(staffData: staff),
                          ),
                        ).then((_) => _fetchStaffData());
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteStaff(staff['phone']),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStaffProcessPage(),
            ),
          ).then((_) => _fetchStaffData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
