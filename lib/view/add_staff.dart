import 'package:flutter/material.dart';
import 'package:kasirku/view/proses_add_staff.dart';
import '../presenter/user_presenter.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final UserPresenter _presenter = UserPresenter(); // Inisialisasi presenter
  List<Map<String, dynamic>> _staffList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStaffData();
  }

  // Mengambil data dari UserPresenter
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Staff')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis pembatas
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(
              color: Colors.grey, // Warna garis
              thickness: 1, // Ketebalan garis
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _staffList.isEmpty
                    ? const Center(child: Text('Belum ada data staff.'))
                    : ListView.builder(
                        itemCount: _staffList.length,
                        itemBuilder: (context, index) {
                          final staff = _staffList[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(staff['image'] ??
                                  'https://via.placeholder.com/150'),
                            ),
                            title: Text(staff['name']),
                            subtitle: Text(staff['phone']),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStaffProcessPage(),
            ),
          ).then((_) => _fetchStaffData()); // Refresh data setelah kembali
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}