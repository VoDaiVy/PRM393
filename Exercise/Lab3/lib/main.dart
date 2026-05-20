import 'package:flutter/material.dart';

// 1. Cấu trúc các Class OOP quản lý nhân viên
abstract class Employee {
  String id;
  String fullName;
  double baseSalary;
  Employee(this.id, this.fullName, this.baseSalary);
  double getIncome();
  double getTax() {
    double income = getIncome();
    if (income < 9000000) return 0.0;
    if (income <= 15000000) return income * 0.10;
    return income * 0.12;
  }
}

class AdministrativeEmployee extends Employee {
  AdministrativeEmployee(String id, String fullName, double baseSalary) : super(id, fullName, baseSalary);
  @override
  double getIncome() => baseSalary;
}

class SalesEmployee extends Employee {
  double salesRevenue;
  double commissionRate;
  SalesEmployee(String id, String fullName, double baseSalary, this.salesRevenue, this.commissionRate) : super(id, fullName, baseSalary);
  @override
  double getIncome() => baseSalary + (salesRevenue * commissionRate);
}

class Manager extends Employee {
  double responsibilityAllowance;
  Manager(String id, String fullName, double baseSalary, this.responsibilityAllowance) : super(id, fullName, baseSalary);
  @override
  double getIncome() => baseSalary + responsibilityAllowance;
}

// 2. Khởi chạy ứng dụng Flutter (Đã sửa tên Class đồng bộ)
void main() => runApp(const SalaryApp());

class SalaryApp extends StatelessWidget {
  const SalaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SalaryManagerScreen(),
    );
  }
}

class SalaryManagerScreen extends StatefulWidget {
  const SalaryManagerScreen({super.key});

  @override
  State<SalaryManagerScreen> createState() => _SalaryManagerScreenState();
}

class _SalaryManagerScreenState extends State<SalaryManagerScreen> {
  // Danh sách nhân viên mẫu hiển thị lên màn hình
  final List<Employee> _employees = [
    AdministrativeEmployee('E01', 'Võ Đại Vỹ', 8000000),
    SalesEmployee('E02', 'Nguyễn Huyền Trân', 6000000, 50000000, 0.2),
    Manager('E03', 'Trần Văn Việt', 12000000, 4000000),
    AdministrativeEmployee('E04', 'Lê Khôi', 10000000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Lương Nhân Viên - Lab 3'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _employees.length,
          itemBuilder: (context, index) {
            final emp = _employees[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  child: Text(emp.id),
                ),
                title: Text(emp.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Thu nhập: ${emp.getIncome().toStringAsFixed(0)} VND | Thuế: ${emp.getTax().toStringAsFixed(0)} VND'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _employees.removeAt(index); // Xóa nhân viên trực tiếp trên giao diện
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}