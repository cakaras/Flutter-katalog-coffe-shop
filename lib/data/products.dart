import '../models/product.dart';

const List<Product> products = [
  Product(
    id: 'espresso',
    name: 'Espresso',
    description:
        'Ekstrak kopi murni yang pekat dengan crema tebal. Cocok untuk kamu yang butuh dorongan energi cepat.',
    price: 15000,
    category: Category.kopi,
    image: 'assets/images/espresso.jpg',
    rating: 4.6,
  ),
  Product(
    id: 'americano',
    name: 'Americano',
    description:
        'Espresso yang dicampur air panas, rasanya ringan, bersih, dan tidak terlalu pahit.',
    price: 18000,
    category: Category.kopi,
    image: 'assets/images/americano.jpg',
    rating: 4.5,
  ),
  Product(
    id: 'cappuccino',
    name: 'Cappuccino',
    description:
        'Perpaduan espresso, susu panas, dan busa susu tebal dengan taburan kakao di atasnya.',
    price: 24000,
    category: Category.kopi,
    image: 'assets/images/cappuccino.jpg',
    rating: 4.8,
  ),
  Product(
    id: 'latte',
    name: 'Caffe Latte',
    description:
        'Espresso lembut dengan susu steamed yang creamy dan latte art cantik di permukaannya.',
    price: 25000,
    category: Category.kopi,
    image: 'assets/images/latte.jpg',
    rating: 4.7,
  ),
  Product(
    id: 'es_kopi',
    name: 'Es Kopi Susu',
    description:
        'Kopi dingin dengan susu segar dan es batu. Menyegarkan untuk menemani tugas kuliah siang hari.',
    price: 22000,
    category: Category.kopi,
    image: 'assets/images/es_kopi.jpg',
    rating: 4.9,
  ),
  Product(
    id: 'matcha',
    name: 'Matcha Latte',
    description:
        'Teh hijau matcha premium dengan susu dingin. Rasanya segar, sedikit pahit, dan manis seimbang.',
    price: 27000,
    category: Category.nonKopi,
    image: 'assets/images/matcha.jpg',
    rating: 4.6,
  ),
  Product(
    id: 'coklat_panas',
    name: 'Coklat Panas',
    description:
        'Coklat pekat yang hangat dan manis, pelukan hangat di hari yang hujan.',
    price: 22000,
    category: Category.nonKopi,
    image: 'assets/images/coklat_panas.jpg',
    rating: 4.4,
  ),
  Product(
    id: 'es_teh',
    name: 'Es Teh Lemon Mint',
    description:
        'Teh dingin dengan perasan lemon dan daun mint segar, ringan dan menyegarkan.',
    price: 16000,
    category: Category.nonKopi,
    image: 'assets/images/es_teh.jpg',
    rating: 4.3,
  ),
  Product(
    id: 'croissant',
    name: 'Croissant Butter',
    description:
        'Pastry renyah berlapis dengan aroma butter yang harum. Pas disantap bersama kopi.',
    price: 20000,
    category: Category.snack,
    image: 'assets/images/croissant.jpg',
    rating: 4.7,
  ),
  Product(
    id: 'cookies',
    name: 'Choco Chip Cookies',
    description:
        'Kue renyah di luar dan lembut di dalam, penuh potongan coklat.',
    price: 14000,
    category: Category.snack,
    image: 'assets/images/cookies.jpg',
    rating: 4.5,
  ),
  Product(
    id: 'kentang_goreng',
    name: 'Kentang Goreng',
    description:
        'Kentang goreng renyah dengan taburan bumbu dan parsley. Cocok untuk dimakan ramai-ramai.',
    price: 18000,
    category: Category.snack,
    image: 'assets/images/kentang_goreng.jpg',
    rating: 4.4,
  ),
  Product(
    id: 'sandwich',
    name: 'Club Sandwich',
    description:
        'Roti gandum panggang dengan isi sayur segar, alpukat, dan lapisan protein.',
    price: 32000,
    category: Category.snack,
    image: 'assets/images/sandwich.jpg',
    rating: 4.6,
  ),
];
