import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

/// Halaman 1: katalog produk (StatefulWidget).
/// State: kata kunci pencarian, kategori terpilih, dan isi keranjang.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final Cart _cart = Cart();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  Category? _category; // null = semua kategori

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filtered => products.where((p) {
        final matchCategory = _category == null || p.category == _category;
        final matchQuery =
            p.name.toLowerCase().contains(_query.trim().toLowerCase());
        return matchCategory && matchQuery;
      }).toList();

  void _quickAdd(Product product) {
    setState(() {
      _cart.add(
        product,
        size: product.isDrink ? DrinkSize.small : null,
        sugar: product.isDrink ? SugarLevel.normal : null,
      );
    });
    _showAddedSnackBar(product.name);
  }

  void _showAddedSnackBar(String name) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$name ditambahkan ke keranjang'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(label: 'LIHAT', onPressed: _openCart),
        ),
      );
  }

  Future<void> _openDetail(Product product) async {
    // Navigator.push mengembalikan nilai yang dikirim lewat Navigator.pop.
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product, cart: _cart),
      ),
    );
    if (!mounted) return;
    setState(() {}); // segarkan badge keranjang
    if (added == true) _showAddedSnackBar(product.name);
  }

  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage(cart: _cart)),
    );
    if (!mounted) return;
    setState(() {}); // keranjang mungkin berubah di halaman lain
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Kopi Kita',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.local_cafe, size: 40),
      children: const [
        Text('Aplikasi katalog dan keranjang belanja kedai kopi, dibuat '
            'dengan Flutter untuk tugas kelompok.\n\n'
            'Foto produk: Wikimedia Commons (lisensi CC0 / CC BY / CC BY-SA). '
            'Daftar kredit lengkap ada di assets/CREDITS.md.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_cafe),
            SizedBox(width: 8),
            Text('Kopi Kita'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tentang aplikasi',
            onPressed: _showAbout,
            icon: const Icon(Icons.info_outline),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Keranjang',
              onPressed: _openCart,
              icon: Badge(
                isLabelVisible: _cart.totalQuantity > 0,
                label: Text('${_cart.totalQuantity}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Cari menu favoritmu...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _categoryChip('Semua', null),
                for (final c in Category.values) _categoryChip(c.label, c),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: theme.colorScheme.outline),
                        const SizedBox(height: 8),
                        const Text('Menu tidak ditemukan'),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    // Jumlah kolom menyesuaikan lebar layar secara otomatis.
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _openDetail(product),
                        onAdd: () => _quickAdd(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, Category? category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: _category == category,
        onSelected: (_) => setState(() => _category = category),
      ),
    );
  }
}
