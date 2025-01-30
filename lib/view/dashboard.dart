import 'package:flutter/material.dart';
import '../presenter/dashboard_presenter.dart';
import '../navigation/app_navigation.dart'; // Impor navigasi
import '../view/login.dart'; // Pastikan ini mengarah ke halaman login

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

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLabaRugiDialog(
      BuildContext context, String phoneNumber, int idStore) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pengeluaran dan Pemasukan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDialogMenuItem(context, Icons.money_off, "Pengeluaran",
                      () {
                    AppNavigation.navigateToPengeluaran(
                        context, phoneNumber, idStore);
                  }),
                  _buildDialogMenuItem(context, Icons.attach_money, "Pemasukan",
                      () {
                    AppNavigation.navigateToPemasukan(
                        context, phoneNumber, idStore);
                  }),
                  _buildDialogMenuItem(context, Icons.history, "Histori", () {
                    AppNavigation.navigateToHistori(
                        context, phoneNumber, idStore);
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// **Membangun Menu Item dalam Modal Dialog**
  Widget _buildDialogMenuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.purple),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah kembali ke halaman sebelumnya
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _selectedIndex == 0
                    ? _buildDashboardContent()
                    : _buildAccountContent(),
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
      ),
    );
  }

  Widget _buildDashboardContent() {
    // Filter menu berdasarkan status user
    final String userStatus = _dashboardData!['user_status'];
    final String phoneNumber =
        _dashboardData!['user_phone_number']; // ✅ Ambil phone_number
    final int idStore = int.parse(_dashboardData!['id_store']);
    // ✅ Ambil id_store

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
              'action': () => AppNavigation.navigateToRiwayatTransaksi(
                  context, phoneNumber) // ✅ Kirim phoneNumber
            },
            {
              'icon': Icons.bar_chart,
              'label': 'Laba Rugi',
              'action': () => _showLabaRugiDialog(
                  context, phoneNumber, idStore) // ✅ Ubah ke modal pop-up
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
            {
              'icon': Icons.inventory, // ✅ Ikon untuk stok
              'label': 'Kelola Stok', // ✅ Label untuk stok
              'action': () => AppNavigation.navigateToStock(context)
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
              'action': () => AppNavigation.navigateToRiwayatTransaksi(
                  context, phoneNumber) // ✅ Kirim phoneNumber
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
          const SizedBox(height: 10), // Spasi sebelum Divider
          const Divider(
            color: Colors.grey, // Warna garis
            thickness: 1, // Ketebalan garis
            indent: 16, // Jarak garis dari kiri
            endIndent: 16, // Jarak garis dari kanan
          ),
          const SizedBox(height: 20), // Spasi setelah Divider

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
                      color: Colors.green),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hai, ${_dashboardData!['user_full_name']}! Ini adalah halaman Akun Anda.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
