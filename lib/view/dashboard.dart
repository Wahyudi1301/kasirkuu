import 'package:flutter/material.dart';
import '../presenter/dashboard_presenter.dart';
import '../navigation/app_navigation.dart'; // Impor navigasi

class DashboardPage extends StatefulWidget {
  final String phoneNumber;

  const DashboardPage({super.key, required this.phoneNumber});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardPresenter _presenter = DashboardPresenter();
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedIndex = 0; // Untuk mengatur tab yang dipilih

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() async {
    try {
      final data = await _presenter.fetchDashboardData(widget.phoneNumber);
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _selectedIndex == 0
                  ? _buildDashboardContent() // Tab Beranda
                  : _buildAccountContent(), // Tab Akun
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardContent() {
    // Filter menu berdasarkan status user
    final String userStatus = _dashboardData!['user_status'];
    final List<Map<String, dynamic>> menuItems = userStatus == 'admin'
        ? [
            {
              'icon': Icons.shopping_cart,
              'label': 'Transaksi',
              'action': () => AppNavigation.navigateToTransaction(context)
            },
            {
              'icon': Icons.history,
              'label': 'History Order',
              'action': () => AppNavigation.navigateToHistory(context)
            },
            {
              'icon': Icons.bar_chart,
              'label': 'Laba Rugi',
              'action': () => AppNavigation.navigateToProfit(context)
            },
            {
              'icon': Icons.group_add,
              'label': 'Tambah Staff',
              'action': () => AppNavigation.navigateToAddStaff(context)
            },
            {
              'icon': Icons.add_box,
              'label': 'Tambah Produk',
              'action': () => AppNavigation.navigateToAddProduct(context)
            },
          ]
        : [
            {
              'icon': Icons.shopping_cart,
              'label': 'Transaksi',
              'action': () => AppNavigation.navigateToTransaction(context)
            },
            {
              'icon': Icons.history,
              'label': 'History Order',
              'action': () => AppNavigation.navigateToHistory(context)
            },
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Profile and Store Info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(_dashboardData![
                        'profile_image_url'] ??
                    'https://via.placeholder.com/150'), // Placeholder gambar profil
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, ${_dashboardData!['user_full_name']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${_dashboardData!['user_status']} di ${_dashboardData!['store_name']}'),
                  Text(_dashboardData!['store_address']),
                  Text(_dashboardData!['store_phone']),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total Sales
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Penjualan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp. ${_dashboardData!['total_sales']}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Menu Section
          const Text(
            'MENU',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuItem(
                  item['icon'], item['label'], item['action']);
            },
          ),
          const SizedBox(height: 20),

          // Hot News Section
          const Text(
            'Hot News',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Jumlah berita
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Berita Terbaru ${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountContent() {
    return Center(
      child: Text(
        'Hai, ${_dashboardData!['user_full_name']}! Ini adalah halaman Akun Anda.',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
