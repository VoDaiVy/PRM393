// Exercise 6: Hàm tính lương dùng cú pháp mũi tên gọn (Arrow syntax)
double calcSalary(double hours, double rate) => hours * rate;

// Exercise 7: Hàm đăng ký sử dụng tham số có tên (Named parameters)
void register({required String name, int age = 18}) {
  print('Đăng ký thành công -> Tên: $name | Tuổi: $age');
}

void main() {
  print('=== EXERCISE 6: SALARY CALCULATION FUNCTION ===');
  // Gọi hàm tính lương với số giờ là 8 và mức lương 150,000 VND
  double salary = calcSalary(8, 150000);
  print('Tổng lương nhận được: $salary VND');


  print('\n=== EXERCISE 7: FUNCTION WITH NAMED PARAMETERS ===');
  // Gọi hàm theo 2 kiểu truyền tham số khác nhau
  register(name: "Vo Dai Vy");              // Kiểu 1: Chỉ truyền tên (tuổi tự lấy mặc định = 18)
  register(name: "Nguyen Van A", age: 22);  // Kiểu 2: Truyền đầy đủ cả tên và tuổi


  print('\n=== EXERCISE 8: NUMBER LIST PROCESSING ===');
  // Tạo danh sách List chứa 10 số nguyên
  List<int> numbers = [12, 5, 8, 23, 44, 7, 90, 11, 14, 3];
  List<int> evens = [];
  List<int> odds = [];

  // Dùng vòng lặp for-in để duyệt qua từng số và phân loại chẵn/lẻ
  for (var num in numbers) {
    if (num % 2 == 0) {
      evens.add(num); // Nếu chia hết cho 2 thì thêm vào danh sách số chẵn
    } else {
      odds.add(num);  // Ngược lại thì thêm vào danh sách số lẻ
    }
  }
  print('Mảng gốc ban đầu: $numbers');
  print('Các số chẵn tìm được: $evens');
  print('Các số lẻ tìm được: $odds');


  print('\n=== EXERCISE 9: SET UNIQUENESS TEST ===');
  // Set là bộ sưu tập đặc biệt, các phần tử bên trong không được phép trùng lặp nhau
  Set<String> courses = {'Flutter', 'Java', 'UI/UX'};
  courses.add('Flutter'); // Thử cố tình thêm một chữ 'Flutter' đã có sẵn
  courses.add('Dart');    // Thêm một từ khóa mới

  print('Danh sách Set cuối cùng: $courses');


  print('\n=== EXERCISE 10: STUDENT SCORE MAP ===');
  // Map lưu dữ liệu theo cặp (Key: Value) gồm Tên và Điểm số tương ứng
  Map<String, int> studentScores = {
    'Dai Vy': 95,
    'Huyen Tran': 98,
    'Vietnl': 88,
    'Khoi': 92
  };

  String topStudent = "";
  int maxScore = -1;

  // Duyệt qua Map để tìm ra bạn có điểm số cao nhất
  studentScores.forEach((name, score) {
    if (score > maxScore) {
      maxScore = score;
      topStudent = name;
    }
  });

  print('Danh sách điểm lớp học: $studentScores');
  print('Sinh viên có điểm cao nhất là: $topStudent với $maxScore điểm');
}