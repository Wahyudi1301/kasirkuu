class LabaRugiData {
  final int id;
  final String phoneNumber;
  final String nameUsers; // ✅ Tambahkan ini
  final int idStore;
  final String transactionType;
  final String nameTransaction;
  final double amount;
  final String description;
  final String date;

  LabaRugiData({
    required this.id,
    required this.phoneNumber,
    required this.nameUsers, // ✅ Tambahkan ini
    required this.idStore,
    required this.transactionType,
    required this.nameTransaction,
    required this.amount,
    required this.description,
    required this.date,
  });

  /// **Konversi JSON dari API ke Model**
  factory LabaRugiData.fromMap(Map<String, dynamic> map) {
    print("📌 Parsing Data: $map");

    return LabaRugiData(
      id: int.parse(map['id'].toString()),
      phoneNumber: map['phone_number'] ?? "",
      nameUsers: map['name_users'] ??
          "Tidak Diketahui", // ✅ Ambil nama pengguna dari API
      idStore: int.parse(map['id_store'].toString()),
      transactionType: map['transaction_type'] ?? "pemasukan",
      nameTransaction: map['name_transaction'] ?? "Tidak Ada Nama",
      amount: double.parse(map['amount'].toString()),
      description: map['description'] ?? "",
      date: map['date'] ?? "",
    );
  }
}
