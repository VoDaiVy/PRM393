
// 1. Lớp cha trừu tượng (Abstract Class) theo sơ đồ UML
abstract class Employee {
  String id;
  String fullName;
  double baseSalary;

  Employee(this.id, this.fullName, this.baseSalary);

  // Phương thức trừu tượng buộc các lớp con phải tự định nghĩa cách tính
  double getIncome();

  // Công thức tính thuế thu nhập cá nhân theo bậc thang của đề bài
  double getTax() {
    double income = getIncome();
    if (income < 9000000) return 0.0;
    if (income <= 15000000) return income * 0.10;
    return income * 0.12;
  }

  // Phương thức hiển thị thông tin cơ bản
  void display() {
    print('ID: $id | Tên: $fullName | Thu nhập: ${getIncome().toStringAsFixed(0)} | Thuế: ${getTax().toStringAsFixed(0)}');
  }
}

// 2. Ba lớp con kế thừa từ lớp cha Employee
class AdministrativeEmployee extends Employee {
  AdministrativeEmployee(super.id, super.fullName, super.baseSalary);

  @override
  double getIncome() => baseSalary;
}

class SalesEmployee extends Employee {
  double salesRevenue;
  double commissionRate;

  SalesEmployee(super.id, super.fullName, super.baseSalary, this.salesRevenue, this.commissionRate);

  @override
  double getIncome() => baseSalary + (salesRevenue * commissionRate);
}

class Manager extends Employee {
  double responsibilityAllowance;

  Manager(super.id, super.fullName, super.baseSalary, this.responsibilityAllowance);

  @override
  double getIncome() => baseSalary + responsibilityAllowance;
}

// 3. Hàm main chứa sẵn dữ liệu mẫu và thực hiện các chức năng cốt lõi của đề bài
void main() {
  // Khởi tạo danh sách nhân viên mẫu (Gồm cả 3 loại nhân viên)
  List<Employee> list = [
    AdministrativeEmployee('E01', 'Võ Đại Vỹ', 8000000),
    SalesEmployee('E02', 'Nguyễn Huyền Trân', 6000000, 50000000, 0.2), // Thu nhập cao do có hoa hồng
    Manager('E03', 'Trần Văn Việt', 12000000, 4000000),
    AdministrativeEmployee('E04', 'Lê Khôi', 10000000),
    SalesEmployee('E05', 'Nguyễn Gia An', 5000000, 20000000, 0.1),
    Manager('E06', 'Phạm Minh Tâm', 15000000, 5000000),
  ];

  print('=== CHỨC NĂNG 1: HIỂN THỊ DANH SÁCH NHÂN VIÊN ===');
  for (var emp in list) {
    emp.display();
  }

  print('\n=== CHỨC NĂNG 2: TÌM KIẾM NHÂN VIÊN THEO ID (Ví dụ: E02) ===');
  String searchId = 'E02';
  var found = list.firstWhere((e) => e.id == searchId, orElse: () => AdministrativeEmployee('', '', 0));
  if (found.id.isNotEmpty) {
    print('Đã tìm thấy nhân viên:');
    found.display();
  } else {
    print('Không tìm thấy nhân viên có ID: $searchId');
  }

  print('\n=== CHỨC NĂNG 3: XÓA NHÂN VIÊN THEO ID (Xóa mã E04) ===');
  list.removeWhere((e) => e.id == 'E04');
  print('-> Đã xóa nhân viên E04 thành công.');

  print('\n=== CHỨC NĂNG 4: SẮP XẾP NHÂN VIÊN THEO TỔNG THU NHẬP (Tăng dần) ===');
  list.sort((a, b) => a.getIncome().compareTo(b.getIncome()));
  for (var emp in list) {
    emp.display();
  }

  print('\n=== CHỨC NĂNG 5: TOP 5 NHÂN VIÊN CÓ THU NHẬP CAO NHẤT ===');
  // Sắp xếp giảm dần để lấy các ông lớn nhất lên đầu
  list.sort((a, b) => b.getIncome().compareTo(a.getIncome()));
  var top5 = list.take(5).toList();
  for (var emp in top5) {
    emp.display();
  }
}