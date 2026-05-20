void main() {
  print('=== EXERCISE 1: EXTENDED HELLO DART ===');
  // Khai báo biến
  String studentName = "Vo Dai Vy";
  int age = 21;
  double gpa = 3.8;

  // In ra màn hình bằng String Interpolation
  print('Tên: $studentName'); 
  print('Tuổi: $age');
  print('GPA: $gpa');


  print('\n=== EXERCISE 2: SIMPLE CALCULATOR ===');
  int a = 15;
  int b = 4;

  // Các phép toán cơ bản
  print('$a + $b = ${a + b}'); 
  print('$a - $b = ${a - b}'); 
  print('$a * $b = ${a * b}'); 
  print('$a / $b = ${a / b}'); 
  print('$a % $b = ${a % b}'); // Chia lấy dư


  print('\n=== EXERCISE 3: VARIABLES AND CONSTANTS ===');
  var mySchool = "FPT University";              // Tự động đoán kiểu dữ liệu
  dynamic flexibleValue = 100;                  // Thay đổi kiểu dữ liệu thoải mái
  flexibleValue = "Đã đổi sang String"; 

  final DateTime currentTime = DateTime.now();  // Hằng số khi chạy app (Runtime)
  const double pi = 3.14159;                    // Hằng số khi biên dịch (Compile-time)

  print('var: $mySchool | dynamic: $flexibleValue');
  print('final: $currentTime | const: $pi');


  print('\n=== EXERCISE 4: STUDENT GRADE CLASSIFICATION ===');
  double myScore = 85.5;
  String classification = "";

  // Cấu trúc điều kiện if/else
  if (myScore < 50) {
    classification = "Fail";
  } else if (myScore <= 65) {
    classification = "Average";
  } else if (myScore <= 80) {
    classification = "Good";
  } else if (myScore <= 100) {
    classification = "Excellent";
  }

  print('Điểm: $myScore => Xếp loại: $classification');


  print('\n=== EXERCISE 5: TASK SCHEDULE BY DAY ===');
  String inputDay = "Mon";

  // Cấu trúc switch-case để so sánh giá trị cụ thể
  switch (inputDay) {
    case "Mon":
      print('Thứ Hai: Học lý thuyết Flutter.');
      break;
    case "Tue":
      print('Thứ Ba: Thực hành code Lab 2.');
      break;
    case "Wed":
      print('Thứ Tư: Tham gia hoạt động dã ngoại.');
      break;
    default:
      print('Các ngày khác: Tự học lập trình.');
  }
}