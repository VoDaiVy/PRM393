import 'package:flutter/material.dart';
import 'dart:ui'; // Bổ sung để dùng BackdropFilter cho Glassmorphism

void main() {
  runApp(const DailyTaskManagerApp());
}

// === MODELS ===

class TaskCategory {
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory(this.name, this.icon, this.color);
}

const List<TaskCategory> defaultCategories = [
  TaskCategory('Công việc', Icons.work_rounded, Color(0xFF4C6FFF)),
  TaskCategory('Cá nhân', Icons.person_rounded, Color(0xFFFF8B4C)),
  TaskCategory('Học tập', Icons.school_rounded, Color(0xFFA55EFE)),
  TaskCategory('Sức khỏe', Icons.favorite_rounded, Color(0xFFFF5284)),
];

class Task {
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  DateTime dueDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  TaskCategory category;

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? createdAt,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    required this.category,
  }) : createdAt = createdAt ?? DateTime.now();
}

// === APP ENTRY ===

class DailyTaskManagerApp extends StatelessWidget {
  const DailyTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Task Manager',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent, // Để lộ gradient nền
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      home: const DashboardScreen(),
    );
  }
}

// === MAIN SCREEN ===

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1: return 'T2';
      case 2: return 'T3';
      case 3: return 'T4';
      case 4: return 'T5';
      case 5: return 'T6';
      case 6: return 'T7';
      case 7: return 'CN';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    return 'Tháng $month';
  }

  List<Task> get _tasksForSelectedDate {
    return _tasks.where((t) => _isSameDay(t.dueDate, _selectedDate)).toList();
  }

  double get _completionProgress {
    final tasks = _tasksForSelectedDate;
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }

  void _addTask(String title, String desc, TaskCategory category, DateTime date, TimeOfDay start, TimeOfDay end) {
    setState(() {
      _tasks.add(Task(
        title: title, 
        description: desc,
        category: category, 
        dueDate: date,
        startTime: start,
        endTime: end,
      ));
      // Sort tasks by start time instead of created at, so they appear in chronological order
      _tasks.sort((a, b) => a.startTime.hour * 60 + a.startTime.minute - (b.startTime.hour * 60 + b.startTime.minute));
    });
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  // === SHOW DETAILS DIALOG ===
  void _showTaskDetails(Task task, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded, size: 20, color: isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Category & Status tag
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: task.category.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(task.category.icon, size: 16, color: task.category.color),
                            const SizedBox(width: 6),
                            Text(
                              task.category.name,
                              style: TextStyle(color: task.category.color, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (task.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
                              const SizedBox(width: 6),
                              const Text('Đã xong', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Time info
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 20, color: isDark ? Colors.white54 : Colors.black54),
                      const SizedBox(width: 12),
                      Text(
                        '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Chi tiết công việc:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : Colors.black38,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      task.description.isEmpty ? 'Không có mô tả chi tiết.' : task.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  // === BOTTOM SHEET CẬP NHẬT (THÊM THỜI GIAN VÀ CHI TIẾT) ===
  void _showAddTaskBottomSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskCategory selectedCategory = defaultCategories.first;
    DateTime selectedTaskDate = _selectedDate;
    TimeOfDay selectedStartTime = TimeOfDay.now();
    TimeOfDay selectedEndTime = TimeOfDay(hour: (TimeOfDay.now().hour + 1) % 24, minute: TimeOfDay.now().minute);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphism cho nền mờ
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85, // Mở rộng chiều cao vì có nhiều ô nhập
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.85),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, -10))
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tạo Công Việc',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: ListView(
                        children: [
                          // Ô nhập tiêu đề
                          TextField(
                            controller: titleController,
                            autofocus: true,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Tiêu đề công việc...',
                              hintStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.normal),
                              filled: true,
                              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ô nhập chi tiết
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung chi tiết (tuỳ chọn)...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Chọn thời gian
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Bắt đầu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(context: context, initialTime: selectedStartTime);
                                        if (time != null) setModalState(() => selectedStartTime = time);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(selectedStartTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Kết thúc', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(context: context, initialTime: selectedEndTime);
                                        if (time != null) setModalState(() => selectedEndTime = time);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(selectedEndTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Danh mục
                          const Text('Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: defaultCategories.map((cat) {
                                final isSel = selectedCategory == cat;
                                return GestureDetector(
                                  onTap: () => setModalState(() => selectedCategory = cat),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSel ? cat.color.withOpacity(0.2) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSel ? cat.color : Colors.grey.withOpacity(0.3),
                                        width: isSel ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(cat.icon, color: isSel ? cat.color : Colors.grey, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          cat.name,
                                          style: TextStyle(
                                            color: isSel ? cat.color : Colors.grey,
                                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                        onPressed: () {
                          if (titleController.text.trim().isNotEmpty) {
                            _addTask(titleController.text.trim(), descController.text.trim(), selectedCategory, selectedTaskDate, selectedStartTime, selectedEndTime);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Thêm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isDark) {
    final cat = task.category;
    return GestureDetector(
      onTap: () => _showTaskDetails(task, isDark),
      child: Dismissible(
        key: ValueKey(task.createdAt.toString()),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            _deleteTask(task);
          } else {
            _toggleTaskCompletion(task);
          }
        },
        background: _buildSwipeAction(isLeft: true),
        secondaryBackground: _buildSwipeAction(isLeft: false),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Nút Check cực nghệ
                    GestureDetector(
                      onTap: () => _toggleTaskCompletion(task),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: task.isCompleted ? cat.color : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: task.isCompleted ? cat.color : Colors.grey.withOpacity(0.5),
                            width: 2.5,
                          ),
                          boxShadow: task.isCompleted ? [
                            BoxShadow(color: cat.color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                          ] : [],
                        ),
                        child: task.isCompleted
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Nội dung
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.w700,
                              color: task.isCompleted 
                                ? Colors.grey.withOpacity(0.6) 
                                : (isDark ? Colors.white : const Color(0xFF1A1A2E)),
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            child: Text(task.title),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: cat.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(cat.icon, size: 14, color: task.isCompleted ? Colors.grey.shade400 : cat.color),
                              ),
                              const SizedBox(width: 8),
                              // Hiện giờ thay vì tên danh mục (để tiện lợi)
                              Text(
                                '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: task.isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // === UI BUILDER ===
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final morningTasks = _tasksForSelectedDate.where((t) => t.startTime.hour < 12).toList();
    final afternoonTasks = _tasksForSelectedDate.where((t) => t.startTime.hour >= 12 && t.startTime.hour < 18).toList();
    final eveningTasks = _tasksForSelectedDate.where((t) => t.startTime.hour >= 18).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
          ]
        ),
        child: FloatingActionButton(
          onPressed: _showAddTaskBottomSheet,
          backgroundColor: Colors.transparent,
          elevation: 0, 
          child: const Icon(Icons.add_rounded, size: 36, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Nền Gradient tinh tế
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                    ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                    : [const Color(0xFFF0F4FF), const Color(0xFFE5E7EB)],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9D4EDD).withOpacity(isDark ? 0.2 : 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF8B4C).withOpacity(isDark ? 0.15 : 0.1),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // HEADER DASHBOARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chào ngày mới,',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sẵn sàng chưa?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: _completionProgress,
                              strokeWidth: 8,
                              strokeCap: StrokeCap.round,
                              backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            '${(_completionProgress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // LỊCH CUỘN NGANG
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 30, 
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index - 5));
                      final isSelected = _isSameDay(date, _selectedDate);
                      final isToday = _isSameDay(date, DateTime.now());

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          width: 75,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            gradient: isSelected 
                              ? const LinearGradient(
                                  colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.6),
                                    isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: isSelected 
                                ? Colors.transparent 
                                : (isToday ? primaryColor.withOpacity(0.5) : Colors.white.withOpacity(0.2)),
                              width: 2,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
                            ] : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getMonthName(date.month),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white.withOpacity(0.8) : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getDayOfWeek(date.weekday),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? Colors.white.withOpacity(0.9) : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // TIÊU ĐỀ DANH SÁCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Việc cần làm',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_tasksForSelectedDate.length} tasks',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // DANH SÁCH CÔNG VIỆC NHÓM THEO THỜI GIAN
                Expanded(
                  child: _tasksForSelectedDate.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_circle_outline_rounded, size: 80, color: Colors.grey.withOpacity(0.5)),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Thật là trống trải!',
                                style: TextStyle(fontSize: 20, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tận hưởng thời gian rảnh\nhoặc thêm ngay việc mới ở dấu + nhé.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade600, fontSize: 15, height: 1.5),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            if (morningTasks.isNotEmpty) ...[
                              _buildSectionHeader('🌅 Buổi sáng', isDark),
                              ...morningTasks.map((t) => _buildTaskCard(t, isDark)),
                            ],
                            if (afternoonTasks.isNotEmpty) ...[
                              _buildSectionHeader('☀️ Buổi chiều', isDark),
                              ...afternoonTasks.map((t) => _buildTaskCard(t, isDark)),
                            ],
                            if (eveningTasks.isNotEmpty) ...[
                              _buildSectionHeader('🌙 Buổi tối', isDark),
                              ...eveningTasks.map((t) => _buildTaskCard(t, isDark)),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeAction({required bool isLeft}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
      decoration: BoxDecoration(
        color: isLeft ? Colors.green : Colors.redAccent,
        borderRadius: BorderRadius.circular(28),
      ),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Icon(
        isLeft ? Icons.check_circle_outline_rounded : Icons.delete_outline_rounded,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
