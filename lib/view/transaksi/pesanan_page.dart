import 'package:flutter/material.dart';
import '../../../model/cart_item.dart';
import '../../../presenter/transaction_presenter.dart';
import 'transaction_page.dart';
import 'proses_pembayaran_page.dart'; // Halaman pembayaran

class PesananPage extends StatefulWidget {
  final List<CartItem> cart;
  final TransactionPresenter presenter;

  const PesananPage({super.key, required this.cart, required this.presenter});

  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // Tombol "+" untuk menambah pesanan
            onPressed: () async {
              final newCart = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionPage(),
                ),
              );

              if (newCart != null) {
                setState(() {
                  widget.cart.addAll(newCart);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(item.name.substring(0, 2)), // Inisial produk
                  ),
                  title: Text(item.name),
                  subtitle: Text("Rp. ${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            item.quantity++;
                          });
                        },
                      ),
                      Text("${item.quantity}"),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) {
                              item.quantity--;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.cart.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.cart.fold<int>(0, (sum, item) => sum + item.quantity)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Order Rp. ${widget.cart.fold<double>(0, (sum, item) => sum + (item.price * item.quantity))}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProsesPembayaranPage(
                          cart: widget.cart,
                          presenter: widget.presenter,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Lanjutkan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
