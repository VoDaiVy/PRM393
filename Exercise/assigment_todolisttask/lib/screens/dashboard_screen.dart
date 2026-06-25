import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../services/task_database.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const DashboardScreen({super.key, required this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  String _username = 'You';
  bool _isLoadingTasks = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final username = await AuthService.getUsername();
    final tasks = await TaskDatabase.instance.getTasks(username);

    if (!mounted) return;
    setState(() {
      _username = username;
      _tasks
        ..clear()
        ..addAll(tasks);
      _sortTasks();
      _isLoadingTasks = false;
    });
  }

  void _sortTasks() {
    _tasks.sort(
      (a, b) =>
          a.startTime.hour * 60 +
          a.startTime.minute -
          (b.startTime.hour * 60 + b.startTime.minute),
    );
  }

  String _formatCreatedAt(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    widget.onLogout();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    return 'Month $month';
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

  Future<void> _addTask(
    String title,
    String desc,
    TaskCategory category,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
    TaskPriority priority,
  ) async {
    final task = Task(
      title: title,
      description: desc,
      category: category,
      dueDate: date,
      startTime: start,
      endTime: end,
      priority: priority,
      ownerEmail: _username,
    );
    task.id = await TaskDatabase.instance.insertTask(task);

    if (!mounted) return;
    setState(() {
      _tasks.add(task);
      _sortTasks();
    });
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    final oldValue = task.isCompleted;
    setState(() {
      task.isCompleted = !oldValue;
    });

    try {
      await TaskDatabase.instance.updateTask(task);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        task.isCompleted = oldValue;
      });
    }
  }

  Future<void> _deleteTask(Task task) async {
    final id = task.id;
    if (id != null) {
      await TaskDatabase.instance.deleteTask(id);
    }

    if (!mounted) return;
    setState(() {
      _tasks.remove(task);
    });
  }

  Future<void> _editTask(
    Task task,
    String title,
    String desc,
    TaskCategory category,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
    TaskPriority priority,
  ) async {
    setState(() {
      task.title = title;
      task.description = desc;
      task.category = category;
      task.dueDate = date;
      task.startTime = start;
      task.endTime = end;
      task.priority = priority;

      _sortTasks();
    });
    await TaskDatabase.instance.updateTask(task);
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
                color: isDark
                    ? Colors.black.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: SingleChildScrollView(
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
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category & Status tag
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: task.category.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              task.category.icon,
                              size: 16,
                              color: task.category.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.category.name,
                              style: TextStyle(
                                color: task.category.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: task.priority.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              task.priority.icon,
                              size: 16,
                              color: task.priority.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.priority.name,
                              style: TextStyle(
                                color: task.priority.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (task.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Time info
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ID: ${task.id ?? 'Unsaved'} - Created at: ${_formatCreatedAt(task.createdAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Task details:',
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
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      task.description.isEmpty
                          ? 'No detailed description.'
                          : task.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: Colors.redAccent,
                            side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTask(task);
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text(
                            'Delete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showAddTaskBottomSheet(existingTask: task);
                          },
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text(
                            'Edit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
          ),
        );
      },
    );
  }

  // === BOTTOM SHEET CẬP NHẬT (THÊM THỜI GIAN VÀ CHI TIẾT) ===
  void _showAddTaskBottomSheet({Task? existingTask}) {
    final titleController = TextEditingController(
      text: existingTask?.title ?? '',
    );
    final descController = TextEditingController(
      text: existingTask?.description ?? '',
    );
    TaskCategory selectedCategory =
        existingTask?.category ?? defaultCategories.first;
    TaskPriority selectedPriority =
        existingTask?.priority ?? TaskPriority.medium;
    DateTime selectedTaskDate = existingTask?.dueDate ?? _selectedDate;
    TimeOfDay selectedStartTime = existingTask?.startTime ?? TimeOfDay.now();
    TimeOfDay selectedEndTime =
        existingTask?.endTime ??
        TimeOfDay(
          hour: (TimeOfDay.now().hour + 1) % 24,
          minute: TimeOfDay.now().minute,
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ), // Glassmorphism cho nền mờ
              child: Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.85, // Mở rộng chiều cao vì có nhiều ô nhập
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                  ],
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
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      existingTask != null ? 'Edit Task' : 'Create Task',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView(
                        children: [
                          // Ô nhập tiêu đề
                          TextField(
                            controller: titleController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Task title...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.normal,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ô nhập chi tiết
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Enter task details (optional)...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
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
                                    const Text(
                                      'Start time',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: selectedStartTime,
                                        );
                                        if (time != null) {
                                          setModalState(
                                            () => selectedStartTime = time,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.05,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.03,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          selectedStartTime.format(context),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
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
                                    const Text(
                                      'End time',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: selectedEndTime,
                                        );
                                        if (time != null) {
                                          setModalState(
                                            () => selectedEndTime = time,
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.05,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.03,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          selectedEndTime.format(context),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Mức độ ưu tiên
                          const Text(
                            'Priority',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: TaskPriority.values.map((p) {
                              final isSel = selectedPriority == p;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setModalState(() => selectedPriority = p),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? p.color.withValues(alpha: 0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSel
                                            ? p.color
                                            : Colors.grey.withValues(
                                                alpha: 0.3,
                                              ),
                                        width: isSel ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          p.icon,
                                          color: isSel ? p.color : Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          p.name,
                                          style: TextStyle(
                                            color: isSel
                                                ? p.color
                                                : Colors.grey,
                                            fontWeight: isSel
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Danh mục
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: defaultCategories.map((cat) {
                              final isSel = selectedCategory == cat;
                              return GestureDetector(
                                onTap: () =>
                                    setModalState(() => selectedCategory = cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSel
                                        ? cat.color.withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSel
                                          ? cat.color
                                          : Colors.grey.withValues(alpha: 0.3),
                                      width: isSel ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        cat.icon,
                                        color: isSel ? cat.color : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat.name,
                                        style: TextStyle(
                                          color: isSel
                                              ? cat.color
                                              : Colors.grey,
                                          fontWeight: isSel
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
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
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          if (titleController.text.trim().isNotEmpty) {
                            if (existingTask != null) {
                              _editTask(
                                existingTask,
                                titleController.text.trim(),
                                descController.text.trim(),
                                selectedCategory,
                                selectedTaskDate,
                                selectedStartTime,
                                selectedEndTime,
                                selectedPriority,
                              );
                            } else {
                              _addTask(
                                titleController.text.trim(),
                                descController.text.trim(),
                                selectedCategory,
                                selectedTaskDate,
                                selectedStartTime,
                                selectedEndTime,
                                selectedPriority,
                              );
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          existingTask != null ? 'Update' : 'Add',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
          color: isDark
              ? Colors.white.withValues(alpha: 0.8)
              : Colors.black.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isDark) {
    final cat = task.category;
    final completedGradient = LinearGradient(
      colors: isDark
          ? [
              const Color(0xFF123B3A).withValues(alpha: 0.92),
              const Color(0xFF203A70).withValues(alpha: 0.88),
            ]
          : [const Color(0xFFE7FFF7), const Color(0xFFE9F0FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final normalCardColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.7);

    return GestureDetector(
      onTap: () => _showTaskDetails(task, isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
        decoration: BoxDecoration(
          gradient: task.isCompleted
              ? completedGradient
              : LinearGradient(
                  colors: [normalCardColor, normalCardColor],
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: task.isCompleted
                ? const Color(0xFF33D9B2).withValues(alpha: isDark ? 0.55 : 0.7)
                : Colors.white.withValues(alpha: 0.2),
            width: task.isCompleted ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: task.isCompleted
                  ? const Color(
                      0xFF33D9B2,
                    ).withValues(alpha: isDark ? 0.18 : 0.16)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: task.isCompleted ? 26 : 20,
              offset: const Offset(0, 12),
            ),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: task.isCompleted
                            ? const LinearGradient(
                                colors: [Color(0xFF33D9B2), Color(0xFF4C6FFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Colors.transparent, Colors.transparent],
                              ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.grey.withValues(alpha: 0.5),
                          width: task.isCompleted ? 2 : 2.5,
                        ),
                        boxShadow: task.isCompleted
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF33D9B2,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: task.isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                key: ValueKey('checked'),
                                color: Colors.white,
                                size: 22,
                              )
                            : const SizedBox(key: ValueKey('unchecked')),
                      ),
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
                            fontWeight: task.isCompleted
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: task.isCompleted
                                ? (isDark
                                      ? const Color(0xFFEFFFFA)
                                      : const Color(0xFF173B48))
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1A2E)),
                          ),
                          child: Text(task.title),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: task.isCompleted
                                        ? Colors.white.withValues(
                                            alpha: isDark ? 0.16 : 0.75,
                                          )
                                        : cat.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    cat.icon,
                                    size: 14,
                                    color: task.isCompleted
                                        ? const Color(0xFF4C6FFF)
                                        : cat.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Hiện giờ thay vì tên danh mục (để tiện lợi)
                                Text(
                                  '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : (task.isCompleted
                                              ? const Color(0xFF39545D)
                                              : Colors.grey.shade800),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            // Mức độ ưu tiên
                            Icon(
                              task.priority.icon,
                              size: 16,
                              color: task.priority.color,
                            ),
                            if (task.isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF33D9B2,
                                  ).withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Color(0xFF119C7C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Delete task',
                    onPressed: () => _deleteTask(task),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.65),
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
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

    final morningTasks = _tasksForSelectedDate
        .where((t) => t.startTime.hour < 12)
        .toList();
    final afternoonTasks = _tasksForSelectedDate
        .where((t) => t.startTime.hour >= 12 && t.startTime.hour < 18)
        .toList();
    final eveningTasks = _tasksForSelectedDate
        .where((t) => t.startTime.hour >= 18)
        .toList();

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
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
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
                color: const Color(
                  0xFF9D4EDD,
                ).withValues(alpha: isDark ? 0.2 : 0.1),
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
                color: const Color(
                  0xFFFF8B4C,
                ).withValues(alpha: isDark ? 0.15 : 0.1),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $_username',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ready?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                  backgroundColor: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.05),
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
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            tooltip: 'Logout',
                            onPressed: _logout,
                            style: IconButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                            icon: Icon(
                              Icons.logout_rounded,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
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
                      final date = DateTime.now().add(
                        Duration(days: index - 5),
                      );
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
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF9D4EDD),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      isDark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.white.withValues(alpha: 0.6),
                                      isDark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.white.withValues(alpha: 0.6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isToday
                                        ? primaryColor.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.2)),
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF6C63FF,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getMonthName(date.month),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : (isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white
                                            : Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getDayOfWeek(date.weekday),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : (isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
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
                        'To-do list',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_tasksForSelectedDate.length} tasks',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // DANH SÁCH CÔNG VIỆC NHÓM THEO THỜI GIAN
                Expanded(
                  child: _isLoadingTasks
                      ? const Center(child: CircularProgressIndicator())
                      : _tasksForSelectedDate.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.white.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 80,
                                  color: Colors.grey.withValues(alpha: 0.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'It\'s so empty here!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enjoy your free time\nor add a new task using the + button.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: [
                            if (morningTasks.isNotEmpty) ...[
                              _buildSectionHeader('🌅 Morning', isDark),
                              ...morningTasks.map(
                                (t) => _buildTaskCard(t, isDark),
                              ),
                            ],
                            if (afternoonTasks.isNotEmpty) ...[
                              _buildSectionHeader('☀️ Afternoon', isDark),
                              ...afternoonTasks.map(
                                (t) => _buildTaskCard(t, isDark),
                              ),
                            ],
                            if (eveningTasks.isNotEmpty) ...[
                              _buildSectionHeader('🌙 Evening', isDark),
                              ...eveningTasks.map(
                                (t) => _buildTaskCard(t, isDark),
                              ),
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
}
