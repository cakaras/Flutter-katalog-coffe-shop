import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kopi_kita/main.dart';
import 'package:kopi_kita/models/cart.dart';
import 'package:kopi_kita/data/products.dart';
import 'package:kopi_kita/models/product.dart';
import 'package:kopi_kita/utils/format.dart';

void main() {
  test('formatRupiah memberi pemisah ribuan', () {
    expect(formatRupiah(0), 'Rp 0');
    expect(formatRupiah(900), 'Rp 900');
    expect(formatRupiah(25000), 'Rp 25.000');
    expect(formatRupiah(1250000), 'Rp 1.250.000');
  });

  test('Cart menggabungkan item sama dan menghitung total', () {
    final cart = Cart();
    final latte = products.firstWhere((p) => p.id == 'latte');
    cart.add(latte, size: DrinkSize.medium, sugar: SugarLevel.normal);
    cart.add(latte, size: DrinkSize.medium, sugar: SugarLevel.normal);
    cart.add(latte, size: DrinkSize.large, sugar: SugarLevel.normal);
    expect(cart.items.length, 2);
    expect(cart.totalQuantity, 3);
    expect(cart.totalPrice, 2 * (25000 + 3000) + (25000 + 6000));
    cart.decrease(cart.items.first);
    cart.decrease(cart.items.first);
    expect(cart.items.length, 1);
  });

  testWidgets('Alur lengkap: katalog -> detail -> keranjang -> checkout',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const KopiKitaApp());
    expect(find.text('Kopi Kita'), findsOneWidget);
    expect(find.text('Espresso'), findsOneWidget);

    // Filter kategori
    await tester.tap(find.text('Snack'));
    await tester.pump();
    expect(find.text('Espresso'), findsNothing);
    expect(find.text('Croissant Butter'), findsOneWidget);
    await tester.tap(find.text('Semua'));
    await tester.pump();

    // Pencarian
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();
    expect(find.text('Menu tidak ditemukan'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'cappu');
    await tester.pump();
    expect(find.text('Cappuccino'), findsOneWidget);

    // Detail -> tambah ke keranjang dengan jumlah 2
    await tester.tap(find.text('Cappuccino'));
    await tester.pumpAndSettle();
    expect(find.text('Ukuran'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add).last);
    await tester.pump();
    await tester.tap(find.textContaining('Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets); // badge keranjang

    // Keranjang
    await tester.tap(find.byTooltip('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Cappuccino'), findsOneWidget);
    expect(find.text('Rp 48.000'), findsWidgets);

    // Checkout: submit kosong -> error validasi
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Pesan Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('Nomor HP wajib diisi'), findsOneWidget);
    expect(find.text('Nomor meja wajib diisi'), findsOneWidget);

    // Isi data valid
    await tester.enterText(find.widgetWithText(TextFormField, 'Nama lengkap'), 'Budi');
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor HP'), '08123456789');
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor meja (1-30)'), '99');
    await tester.tap(find.textContaining('Pesan Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Nomor meja harus 1 - 30'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextFormField, 'Nomor meja (1-30)'), '7');
    await tester.tap(find.textContaining('Pesan Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan Berhasil!'), findsOneWidget);

    // Kembali ke katalog, keranjang kosong
    await tester.tap(find.text('Kembali ke Menu'));
    await tester.pumpAndSettle();
    expect(find.text('Kopi Kita'), findsOneWidget);
    expect(find.byType(Badge), findsOneWidget);
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
  });
}
