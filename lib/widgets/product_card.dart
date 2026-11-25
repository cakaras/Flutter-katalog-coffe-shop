import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/format.dart';

/// Kartu produk pada grid katalog (StatelessWidget: tidak punya state sendiri).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'produk-${product.id}',
                child: ProductImage(path: product.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(product.rating.toString(),
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatRupiah(product.price),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Tambah ke keranjang',
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gambar produk dari aset, dengan ikon cadangan jika file tidak ditemukan.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Icon(Icons.local_cafe, size: 48),
      ),
    );
  }
}
