class Product {
  final int idProduct;
  final int idKategori;
  final String nameProduct;
  final String deskripsi;
  final int hargaBeli;
  final int hargaJual;
  final int stok;
  final int idUnit;
  final String img;

  Product({
    required this.idProduct,
    required this.idKategori,
    required this.nameProduct,
    required this.deskripsi,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    required this.idUnit,
    required this.img,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: int.tryParse(json['id_product'].toString()) ?? 0,
      idKategori: int.tryParse(json['id_kategori'].toString()) ?? 0,
      nameProduct: json['name_product'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      hargaBeli: int.tryParse(json['harga_beli'].toString()) ?? 0,
      hargaJual: int.tryParse(json['harga_jual'].toString()) ?? 0,
      stok: int.tryParse(json['stok'].toString()) ?? 0,
      idUnit: int.tryParse(json['id_unit'].toString()) ?? 0,
      img: json['img'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id_kategori'].toString()),
      name: json['name_kategori'].toString(),
    );
  }
}

class Unit {
  final int id;
  final String name;

  Unit({required this.id, required this.name});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: int.parse(json['id_unit'].toString()),
      name: json['name_unit'].toString(),
    );
  }
}
