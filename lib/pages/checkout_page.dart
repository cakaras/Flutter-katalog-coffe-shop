import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cart.dart';
import '../utils/format.dart';

enum OrderType {
  dineIn('Makan di tempat'),
  delivery('Antar ke alamat');

  const OrderType(this.label);
  final String label;
}

/// Halaman 4: form checkout dengan validasi (TextFormField + Form).
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.cart});

  final Cart cart;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _detailController = TextEditingController(); // nomor meja / alamat
  final _noteController = TextEditingController();
  OrderType _orderType = OrderType.dineIn;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _detailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ---- Validator: mengembalikan teks error, atau null jika valid ----

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Nama wajib diisi';
    if (text.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Nomor HP wajib diisi';
    if (!RegExp(r'^(08|628)\d{8,11}$').hasMatch(text)) {
      return 'Gunakan format 08xxxxxxxxxx (10-13 digit)';
    }
    return null;
  }

  String? _validateDetail(String? value) {
    final text = value?.trim() ?? '';
    if (_orderType == OrderType.dineIn) {
      final table = int.tryParse(text);
      if (text.isEmpty) return 'Nomor meja wajib diisi';
      if (table == null || table < 1 || table > 30) {
        return 'Nomor meja harus 1 - 30';
      }
    } else {
      if (text.isEmpty) return 'Alamat wajib diisi';
      if (text.length < 10) return 'Alamat terlalu singkat (min. 10 karakter)';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali data yang diisi')),
      );
      return;
    }

    final total = widget.cart.totalPrice;
    final name = _nameController.text.trim();
    final orderNumber =
        'KK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    widget.cart.clear();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 56),
        title: const Text('Pesanan Berhasil!'),
        content: Text(
          'Terima kasih, $name.\n'
          'Nomor pesanan: $orderNumber\n'
          'Total: ${formatRupiah(total)}\n\n'
          'Pesananmu sedang kami siapkan.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              // kembali sampai halaman paling awal (katalog)
              Navigator.popUntil(this.context, (route) => route.isFirst);
            },
            child: const Text('Kembali ke Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.cart;
    final isDineIn = _orderType == OrderType.dineIn;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ringkasan Pesanan',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (final item in cart.items)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.quantity}x ${item.product.name}'
                                      '${item.optionsLabel.isEmpty ? '' : '\n${item.optionsLabel}'}',
                                    ),
                                  ),
                                  Text(formatRupiah(item.subtotal)),
                                ],
                              ),
                            ),
                          const Divider(),
                          Row(
                            children: [
                              const Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(
                                formatRupiah(cart.totalPrice),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Data Pemesan',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Nomor HP',
                      hintText: '08123456789',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validatePhone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<OrderType>(
                    initialValue: _orderType,
                    decoration: const InputDecoration(
                      labelText: 'Jenis pesanan',
                      prefixIcon: Icon(Icons.storefront_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final t in OrderType.values)
                        DropdownMenuItem(value: t, child: Text(t.label)),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _orderType = value;
                        _detailController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: ValueKey(_orderType), // buat ulang saat jenis berubah
                    controller: _detailController,
                    keyboardType:
                        isDineIn ? TextInputType.number : TextInputType.streetAddress,
                    maxLines: isDineIn ? 1 : 2,
                    inputFormatters: isDineIn
                        ? [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ]
                        : null,
                    decoration: InputDecoration(
                      labelText: isDineIn ? 'Nomor meja (1-30)' : 'Alamat lengkap',
                      prefixIcon: Icon(isDineIn
                          ? Icons.table_restaurant_outlined
                          : Icons.location_on_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    validator: _validateDetail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      prefixIcon: Icon(Icons.edit_note),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: Text('Pesan Sekarang • ${formatRupiah(cart.totalPrice)}'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
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
}
