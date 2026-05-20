// Exercise 11: Lớp Student chứa thông tin sinh viên
class Student {
  String name;
  int age;
  double gpa;

  // Constructor: Hàm khởi tạo để nạp dữ liệu khi tạo đối tượng
  Student(this.name, this.age, this.gpa);

  // Ghi đè phương thức toString để khi in đối tượng ra sẽ hiện chữ đẹp đẽ
  @override
  String toString() => 'Sinh viên: $name | Tuổi: $age | GPA: $gpa';
}

// Exercise 12: Lớp Product chứa thông tin sản phẩm và phương thức tính tiền
class Product {
  String id;
  String name;
  double price;
  int quantity;

  Product(this.id, this.name, this.price, this.quantity);

  // Phương thức tính tổng số tiền của sản phẩm đó
  double total() => price * quantity;
}

// Exercise 13: Thực hành tính Kế thừa (Inheritance)
class Person {
  String name;
  Person(this.name);

  void info() => print('Tôi là một người tên là: $name');
}

// Lớp Employee kế thừa (extends) từ lớp Person
class Employee extends Person {
  String company;

  // Constructor gọi lại hàm khởi tạo super của lớp cha Person
  Employee(String name, this.company) : super(name);

  // Ghi đè (Override) lại phương thức info của lớp cha thành thông tin mới
  @override
  void info() => print('Tôi là nhân viên $name, đang làm việc tại $company');
}

void main() {
  print('=== EXERCISE 11: STUDENT CLASS & LIST ===');
  // Tạo danh sách chứa 5 đối tượng Sinh viên
  List<Student> studentList = [
    Student('Dai Vy', 21, 3.8),
    Student('Huyen Tran', 21, 3.9),
    Student('Vietnl', 22, 3.5),
    Student('Khoi', 21, 3.6),
    Student('Gia An', 20, 3.2),
  ];

  // Duyệt qua danh sách và in từng sinh viên ra màn hình
  studentList.forEach((st) => print(st));


  print('\n=== EXERCISE 12: PRODUCT TOTAL VALUE ===');
  // Khởi tạo một sản phẩm cụ thể
  Product prod = Product('P01', 'MacBook Pro M2', 30000000, 2);
  print('Sản phẩm: ${prod.name}');
  print('Số lượng: ${prod.quantity} cái | Đơn giá: ${prod.price.toStringAsFixed(0)} VND');
  print('=> Tổng giá trị hàng hóa: ${prod.total().toStringAsFixed(0)} VND');


  print('\n=== EXERCISE 13: INHERITANCE PRACTICE ===');
  Person ordinaryPerson = Person('Nguyễn Văn A');
  Employee devEmployee = Employee('Võ Đại Vỹ', 'FPT University');

  // Gọi phương thức info để thấy tính đa hình (Polymorphism)
  ordinaryPerson.info(); // Chạy hàm gốc của lớp cha
  devEmployee.info();    // Chạy hàm đã được ghi đè ở lớp con
}