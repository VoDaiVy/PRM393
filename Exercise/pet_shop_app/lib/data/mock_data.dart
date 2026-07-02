import '../models/product.dart';
import '../models/user.dart';

class MockData {
  // ─────────────────────────────────────────────────────────────────────────
  // MOCK USERS
  // Bạn có thể tự thêm / sửa / xoá tài khoản ở đây.
  // Lưu ý: role chỉ nhận 'admin' hoặc 'user'.
  // ─────────────────────────────────────────────────────────────────────────
  static final List<User> users = [
    User(
      id: 'u1',
      fullName: 'Admin',
      email: 'admin@gmail.com',
      password: '123',
      role: 'admin',
    ),
    User(
      id: 'u2',
      fullName: 'Test User',
      email: 'user@gmail.com',
      password: '123',
      role: 'user',
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // MOCK PRODUCTS
  // Bạn có thể tự thêm / sửa / xoá sản phẩm ở đây.
  //
  // Cách thêm sản phẩm mới:
  //   Product(
  //     id: 'p<số tiếp theo>',        ← ID duy nhất, không được trùng
  //     name: 'Tên sản phẩm',
  //     description: 'Mô tả ngắn',
  //     price: 0.0,                   ← Giá (đơn vị: USD hoặc tuỳ bạn)
  //     imageUrl: 'https://...',      ← Link ảnh (có thể để null)
  //     category: 'Food',            ← Danh mục: Food | Toys | Accessories | Healthcare | Others
  //   ),
  //
  // Các category hiện tại: Food, Toys, Accessories, Healthcare, Others
  // ─────────────────────────────────────────────────────────────────────────
  static final List<Product> products = [
    // ── FOOD ─────────────────────────────────────────────────────────────
    Product(
      id: 'p1',
      name: 'Premium Dog Food',
      description:
          'High quality dry food for adult dogs. Packed with nutrients, 5kg bag.',
      price: 29.99,
      imageUrl: 'https://images.unsplash.com/photo-1589924691995-400dc9ce5ce1',
      category: 'Food',
    ),
    Product(
      id: 'p2',
      name: 'Grain-Free Cat Food',
      description:
          'Natural grain-free wet food for cats. Real tuna & salmon, 12 cans.',
      price: 22.50,
      imageUrl: 'https://images.unsplash.com/photo-1601758003122-53c40e686a19',
      category: 'Food',
    ),
    Product(
      id: 'p3',
      name: 'Puppy Starter Kit',
      description:
          'Complete nutrition kit for puppies under 12 months. Includes dry & wet food.',
      price: 34.99,
      imageUrl: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee',
      category: 'Food',
    ),
    Product(
      id: 'p4',
      name: 'Bird Seed Mix',
      description: 'Premium seed blend for parrots and small birds. 1kg.',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3',
      category: 'Food',
    ),

    // ── TOYS ─────────────────────────────────────────────────────────────
    Product(
      id: 'p5',
      name: 'Interactive Cat Toy',
      description:
          'Feather wand toy with bell to keep your cat active and entertained.',
      price: 8.99,
      imageUrl: 'https://images.unsplash.com/photo-1545249390-6bdfa286032f',
      category: 'Toys',
    ),
    Product(
      id: 'p6',
      name: 'Rope Chew Toy for Dogs',
      description:
          'Durable braided rope toy for aggressive chewers. Helps clean teeth.',
      price: 11.00,
      imageUrl: 'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69',
      category: 'Toys',
    ),
    Product(
      id: 'p7',
      name: 'Automatic Laser Pointer',
      description:
          'Rotating laser toy that keeps cats busy for hours. 2 speed modes.',
      price: 19.99,
      imageUrl: 'https://images.unsplash.com/photo-1625321171099-5e7d3aa9d3f0',
      category: 'Toys',
    ),

    // ── ACCESSORIES ──────────────────────────────────────────────────────
    Product(
      id: 'p8',
      name: 'Stainless Steel Pet Bowl',
      description:
          'Durable, dishwasher-safe bowl for food or water. Non-slip base.',
      price: 12.50,
      imageUrl: 'https://images.unsplash.com/photo-1599839619722-39751411ea63',
      category: 'Accessories',
    ),
    Product(
      id: 'p9',
      name: 'Retractable Dog Leash',
      description:
          '16ft heavy duty leash for dogs up to 110 lbs. One-button lock.',
      price: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1605342416999-52e8d35677d2',
      category: 'Accessories',
    ),
    Product(
      id: 'p10',
      name: 'Cozy Pet Bed – Medium',
      description:
          'Orthopedic memory foam bed with removable washable cover. Fits cats & small dogs.',
      price: 39.99,
      imageUrl: 'https://images.unsplash.com/photo-1591946614720-90a587da4a36',
      category: 'Accessories',
    ),
    Product(
      id: 'p11',
      name: 'Adjustable Dog Collar',
      description:
          'Nylon collar with reflective stripe. Available sizes: S, M, L.',
      price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1622020457014-4f13d9b7e8f6',
      category: 'Accessories',
    ),
    Product(
      id: 'p12',
      name: 'Cat Carrier Bag',
      description:
          'Airline-approved soft carrier with mesh windows. Fits cats up to 6kg.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1606214174585-fe31582dc6ee',
      category: 'Accessories',
    ),

    // ── HEALTHCARE ───────────────────────────────────────────────────────
    Product(
      id: 'p13',
      name: 'Pet Vitamin Supplement',
      description:
          'Daily multivitamin chews for dogs. Supports joints, coat & immunity.',
      price: 24.99,
      imageUrl: 'https://images.unsplash.com/photo-1585435557343-3b092031a831',
      category: 'Healthcare',
    ),
    Product(
      id: 'p14',
      name: 'Dog Shampoo – Sensitive Skin',
      description:
          'Hypoallergenic formula with oatmeal & aloe vera. 500ml bottle.',
      price: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7',
      category: 'Healthcare',
    ),
    Product(
      id: 'p15',
      name: 'Flea & Tick Spray',
      description:
          'Natural peppermint-based spray. Safe for cats, dogs and home use.',
      price: 17.50,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTIm2sGG-zszVlg1rUKZo1LYquyvCq8jSbXICoEjkf0Cb_QuwrSW3Bq0qN&s=10',
      category: 'Healthcare',
    ),
  ];
}
