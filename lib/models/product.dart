/// Kategori menu pada katalog.
enum Category {
  kopi('Kopi'),
  nonKopi('Non-Kopi'),
  snack('Snack');

  const Category(this.label);
  final String label;
}

/// Ukuran minuman beserta tambahan harganya.
enum DrinkSize {
  small('Small', 0),
  medium('Medium', 3000),
  large('Large', 6000);

  const DrinkSize(this.label, this.extraPrice);
  final String label;
  final int extraPrice;
}

/// Tingkat gula minuman.
enum SugarLevel {
  normal('Normal'),
  less('Kurang Manis'),
  none('Tanpa Gula');

  const SugarLevel(this.label);
  final String label;
}

/// Data satu produk pada katalog.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    this.rating = 4.5,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final Category category;
  final String image;
  final double rating;

  /// Hanya minuman yang punya pilihan ukuran dan gula.
  bool get isDrink => category != Category.snack;
}
