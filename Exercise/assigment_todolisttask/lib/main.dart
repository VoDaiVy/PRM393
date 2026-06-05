import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Nền xám nhạt hiện đại
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _currentFilter = 'All';

  List<Task> get _filteredAndSortedTasks {
    List<Task> filtered;
    if (_currentFilter == 'Completed') {
      filtered = _tasks.where((task) => task.isCompleted).toList();
    } else if (_currentFilter == 'Incomplete') {
      filtered = _tasks.where((task) => !task.isCompleted).toList();
    } else {
      filtered = List.from(_tasks);
    }
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Mới nhất lên trên
    return filtered;
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  void _addTask() {
    final String text = _taskController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên công việc!')),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(title: text));
    });
    _taskController.clear();
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

  void _editTask(Task task) {
    final TextEditingController editController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Chỉnh sửa công việc', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: 'Tên công việc',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final newText = editController.text.trim();
                if (newText.isNotEmpty) {
                  setState(() {
                    task.title = newText;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayTasks = _filteredAndSortedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Khu vực nhập liệu (Được thiết kế lại đẹp hơn)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Thêm công việc mới...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.add, size: 28),
                ),
              ],
            ),
          ),

          // Khu vực Thống kê & Bộ lọc (Dùng FilterChip thay vì Dropdown cho hiện đại)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng: ${_tasks.length} | Đã xong: $_completedCount',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildFilterChip('All', 'Tất cả'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Incomplete', 'Đang làm'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed', 'Hoàn thành'),
                  ],
                ),
              ],
            ),
          ),

          // Danh sách công việc
          Expanded(
            child: displayTasks.isEmpty
                ? const Center(
                    child: Text('Không có công việc nào!', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: displayTasks.length,
                    itemBuilder: (context, index) {
                      final task = displayTasks[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          onTap: () => _toggleTaskCompletion(task), // Bấm vào thẻ để check luôn cho tiện
                          leading: IconButton(
                            icon: Icon(
                              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              color: task.isCompleted ? Colors.green : Colors.grey[400],
                              size: 28,
                            ),
                            onPressed: () => _toggleTaskCompletion(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.w500,
                              color: task.isCompleted ? Colors.grey : Colors.black87,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            'Tạo lúc: ${task.createdAt.hour}:${task.createdAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                                onPressed: () => _editTask(task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => _deleteTask(task),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget tạo ra các nút bấm Lọc (FilterChip) cho đẹp
  Widget _buildFilterChip(String value, String label) {
    final isSelected = _currentFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = value;
          });
        }
      },
      selectedColor: Colors.indigo.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Colors.indigo : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.indigo : Colors.grey.shade300,
        ),
      ),
    );
  }
}
