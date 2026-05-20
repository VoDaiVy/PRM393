import 'dart:async';

// Định nghĩa lớp Product cho dự án Giỏ hàng (Ex 16)
class Product {
  String id;
  String name;
  double price;
  int quantity;

  Product(this.id, this.name, this.price, this.quantity);

  double total() => price * quantity;
}

// Định nghĩa lớp Question cho dự án Trắc nghiệm (Ex 17)
class Question {
  String text;
  List<String> options;
  int correctIndex;

  Question(this.text, this.options, this.correctIndex);
}

// Hàm giả lập tải dữ liệu giỏ hàng mất 1.5 giây
Future<void> simulateLoading() async {
  print('Đang đồng bộ giỏ hàng với hệ thống...');
  await Future.delayed(Duration(milliseconds: 1500));
}

void main() async {
  print('=== EXERCISE 16: MINI PROJECT – CART SYSTEM ===');
  // 1. Khởi tạo danh sách giỏ hàng
  List<Product> cart = [];

  // 2. Thêm sản phẩm vào giỏ
  cart.add(Product('P01', 'Vòng tay gỗ Bách Xanh', 450000, 1));
  cart.add(Product('P02', 'Đồng phục Hướng đạo', 350000, 2));
  cart.add(Product('P03', 'Sách truyện Cậu bé rừng xanh', 100000, 1));
  print('-> Đã thêm 3 sản phẩm vào giỏ hàng.');

  // 3. Xóa sản phẩm có mã P03 khỏi giỏ
  cart.removeWhere((item) => item.id == 'P03');
  print('-> Đã xóa sản phẩm P03 ra khỏi giỏ.');

  // 4. Giả lập hiệu ứng tải dữ liệu bất đồng bộ
  await simulateLoading();

  // 5. Tính tổng tiền giỏ hàng dùng vòng lặp
  double cartTotal = 0;
  for (var item in cart) {
    cartTotal += item.total();
  }
  print('>> TỔNG KẾT TIỀN GIỎ HÀNG: ${cartTotal.toStringAsFixed(0)} VND <<\n');


  print('=== EXERCISE 17: MINI PROJECT – QUIZ SYSTEM ===');
  // 1. Tạo ngân hàng câu hỏi
  List<Question> quizBank = [
    Question('Flutter sử dụng ngôn ngữ lập trình nào chính?', ['Java', 'Dart', 'Python', 'C++'], 1),
    Question('Hàm nào là điểm khởi chạy (entry point) của app Dart?', ['runApp()', 'main()', 'build()'], 1),
  ];

  // 2. Sử dụng vòng lặp để hiển thị câu hỏi và đáp án đúng
  print('--- Bắt đầu hiển thị bộ câu hỏi trắc nghiệm ---');
  for (int i = 0; i < quizBank.length; i++) {
    var q = quizBank[i];
    print('Câu ${i + 1}: ${q.text}');
    
    for (int j = 0; j < q.options.length; j++) {
      print('  [${j + 1}] ${q.options[j]}');
    }
    print('  => Đáp án đúng: Mục số ${q.correctIndex + 1}\n');
  }
  print('================================================');
}