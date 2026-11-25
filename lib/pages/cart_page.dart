import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../utils/format.dart';
import '../widgets/product_card.dart';
import 'checkout_page.dart';

/// Halaman 3: keranjang belanja. Total harga berubah dinamis lewat setState().
class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.cart});

  final Cart cart;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Cart get _cart => widget.cart;

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kosongkan keranjang?'),
        content: const Text('Semua item di keranjang akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
    if (ok == true) setState(_cart.clear);
  }

  void _removeWithUndo(CartItem item) {
    final index = _cart.items.indexOf(item);
    setState(() => _cart.remove(item));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.product.name} dihapus'),
          action: SnackBarAction(
            label: 'BATAL',
            onPressed: () => setState(() => _cart.items.insert(
                  index.clamp(0, _cart.items.length),
                  item,
                )),
          ),
        ),
      );
  }

  Future<void> _goCheckout() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutPage(cart: _cart)),
    );
    if (!mounted) return;
    setState(() {}); // keranjang dikosongkan jika pesanan sukses
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        actions: [
          if (!_cart.isEmpty)
            IconButton(
              tooltip: 'Kosongkan keranjang',
              onPressed: _confirmClear,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: _cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('Keranjang masih kosong',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Lihat Menu'),
                  ),
                ],
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cart.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _buildItem(_cart.items[index], theme),
                ),
              ),
            ),
      bottomNavigationBar: _cart.isEmpty
          ? null
          : SafeArea(
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total (${_cart.totalQuantity} item)',
                                  style: theme.textTheme.bodySmall),
                              Text(
                                formatRupiah(_cart.totalPrice),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _goCheckout,
                          icon: const Icon(Icons.payment),
                          label: const Text('Checkout'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(140, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildItem(CartItem item, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: ProductImage(path: item.product.image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (item.optionsLabel.isNotEmpty)
                    Text(item.optionsLabel, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(formatRupiah(item.subtotal),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Hapus',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _removeWithUndo(item),
                  icon: const Icon(Icons.close, size: 20),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.outlined(
                      tooltip: 'Kurangi',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => item.quantity > 1
                          ? setState(() => _cart.decrease(item))
                          : _removeWithUndo(item),
                      icon: const Icon(Icons.remove, size: 18),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text('${item.quantity}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium),
                    ),
                    IconButton.outlined(
                      tooltip: 'Tambah',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => setState(() => _cart.increase(item)),
                      icon: const Icon(Icons.add, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
