import 'product.dart';

/// Satu baris di keranjang: produk + pilihan + jumlah.
class CartItem {
  CartItem({
    required this.product,
    required this.quantity,
    this.size,
    this.sugar,
  });

  final Product product;
  final DrinkSize? size;
  final SugarLevel? sugar;
  int quantity;

  int get unitPrice => product.price + (size?.extraPrice ?? 0);
  int get subtotal => unitPrice * quantity;

  /// Dua item dianggap sama jika produk dan pilihannya sama.
  bool sameAs(Product p, DrinkSize? s, SugarLevel? g) =>
      product.id == p.id && size == s && sugar == g;

  /// Ringkasan pilihan, contoh: "Medium • Kurang Manis".
  String get optionsLabel => [
        if (size != null) size!.label,
        if (sugar != null) sugar!.label,
      ].join(' • ');
}

/// Keranjang belanja. Objek ini dipakai bersama oleh semua halaman,
/// sedangkan setiap halaman memperbarui tampilannya dengan setState().
class Cart {
  final List<CartItem> items = [];

  bool get isEmpty => items.isEmpty;
  int get totalQuantity => items.fold(0, (sum, i) => sum + i.quantity);
  int get totalPrice => items.fold(0, (sum, i) => sum + i.subtotal);

  void add(Product product, {DrinkSize? size, SugarLevel? sugar, int quantity = 1}) {
    for (final item in items) {
      if (item.sameAs(product, size, sugar)) {
        item.quantity += quantity;
        return;
      }
    }
    items.add(CartItem(
      product: product,
      quantity: quantity,
      size: size,
      sugar: sugar,
    ));
  }

  void increase(CartItem item) => item.quantity++;

  /// Mengurangi jumlah; item dihapus jika jumlahnya menjadi 0.
  void decrease(CartItem item) {
    item.quantity--;
    if (item.quantity <= 0) items.remove(item);
  }

  void remove(CartItem item) => items.remove(item);

  void clear() => items.clear();
}
