import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../utils/format.dart';
import '../widgets/product_card.dart';

/// Halaman 2: detail produk dengan pilihan ukuran, gula, dan jumlah.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.product,
    required this.cart,
  });

  final Product product;
  final Cart cart;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  DrinkSize _size = DrinkSize.small;
  SugarLevel _sugar = SugarLevel.normal;
  int _quantity = 1;

  int get _unitPrice =>
      widget.product.price + (widget.product.isDrink ? _size.extraPrice : 0);

  void _addToCart() {
    final p = widget.product;
    widget.cart.add(
      p,
      size: p.isDrink ? _size : null,
      sugar: p.isDrink ? _sugar : null,
      quantity: _quantity,
    );
    Navigator.pop(context, true); // kembali dan kirim hasil "berhasil"
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Layar lebar: gambar dan detail berdampingan. Layar sempit: menumpuk.
          final wide = constraints.maxWidth >= 700;
          final image = ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Hero(
              tag: 'produk-${product.id}',
              child: ProductImage(path: product.image),
            ),
          );
          final details = _buildDetails(theme);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AspectRatio(aspectRatio: 1, child: image),
                          ),
                          const SizedBox(width: 24),
                          Expanded(child: details),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(aspectRatio: 4 / 3, child: image),
                          const SizedBox(height: 16),
                          details,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: FilledButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  'Tambah ke Keranjang • ${formatRupiah(_unitPrice * _quantity)}',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(ThemeData theme) {
    final product = widget.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(label: Text(product.category.label)),
            const Icon(Icons.star_rounded, color: Colors.amber),
            Text('${product.rating}'),
          ],
        ),
        const SizedBox(height: 8),
        Text(product.name,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          formatRupiah(_unitPrice),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(product.description, style: theme.textTheme.bodyLarge),
        if (product.isDrink) ...[
          const SizedBox(height: 20),
          Text('Ukuran', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<DrinkSize>(
            segments: [
              for (final s in DrinkSize.values)
                ButtonSegment(
                  value: s,
                  label: Text(s.extraPrice == 0
                      ? s.label
                      : '${s.label} +${formatRupiah(s.extraPrice).substring(3)}'),
                ),
            ],
            selected: {_size},
            onSelectionChanged: (value) => setState(() => _size = value.first),
          ),
          const SizedBox(height: 20),
          Text('Tingkat gula', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final s in SugarLevel.values)
                ChoiceChip(
                  label: Text(s.label),
                  selected: _sugar == s,
                  onSelected: (_) => setState(() => _sugar = s),
                ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Text('Jumlah', style: theme.textTheme.titleMedium),
            const Spacer(),
            IconButton.outlined(
              tooltip: 'Kurangi',
              onPressed:
                  _quantity > 1 ? () => setState(() => _quantity--) : null,
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 48,
              child: Text('$_quantity',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge),
            ),
            IconButton.outlined(
              tooltip: 'Tambah',
              onPressed:
                  _quantity < 20 ? () => setState(() => _quantity++) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
