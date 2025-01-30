class Stock {
  final int idProduct;
  final String nameProduct;
  final int stok; // Stok saat ini

  Stock({
    required this.idProduct,
    required this.nameProduct,
    required this.stok,
  });

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      idProduct: map['id_product'],
      nameProduct: map['name_product'],
      stok: int.parse(map['stok'].toString()),
    );
  }
}

class StockLog {
  final int id;
  final int idProduct;
  final int perubahan;
  final int stokAwal;
  final int stokAkhir;
  final String tanggal;

  StockLog({
    required this.id,
    required this.idProduct,
    required this.perubahan,
    required this.stokAwal,
    required this.stokAkhir,
    required this.tanggal,
  });

  factory StockLog.fromMap(Map<String, dynamic> map) {
    return StockLog(
      id: map['id'],
      idProduct: map['id_product'],
      perubahan: map['perubahan'],
      stokAwal: map['stok_awal'],
      stokAkhir: map['stok_akhir'],
      tanggal: map['tanggal'],
    );
  }
}
