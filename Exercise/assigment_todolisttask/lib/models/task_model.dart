import 'package:flutter/material.dart';

enum TaskPriority { high, medium, low }

extension TaskPriorityExt on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.high:
        return const Color(0xFFFF5252);
      case TaskPriority.medium:
        return const Color(0xFFFFB142);
      case TaskPriority.low:
        return const Color(0xFF33D9B2);
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.high:
        return Icons.keyboard_double_arrow_up_rounded;
      case TaskPriority.medium:
        return Icons.drag_handle_rounded;
      case TaskPriority.low:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }
}

class TaskCategory {
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory(this.name, this.icon, this.color);
}

const List<TaskCategory> defaultCategories = [
  TaskCategory('Work', Icons.work_rounded, Color(0xFF4C6FFF)),
  TaskCategory('Personal', Icons.person_rounded, Color(0xFFFF8B4C)),
  TaskCategory('Study', Icons.school_rounded, Color(0xFFA55EFE)),
  TaskCategory('Health', Icons.favorite_rounded, Color(0xFFFF5284)),
];

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  DateTime dueDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  TaskCategory category;
  TaskPriority priority;
  String? ownerEmail;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? createdAt,
    required this.dueDate,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.priority = TaskPriority.medium,
    this.ownerEmail,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'startMinutes': startTime.hour * 60 + startTime.minute,
      'endMinutes': endTime.hour * 60 + endTime.minute,
      'categoryName': category.name,
      'priorityIndex': priority.index,
      'ownerEmail': ownerEmail,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final startMinutes = map['startMinutes'] as int;
    final endMinutes = map['endMinutes'] as int;
    final categoryName = map['categoryName'] as String;
    final priorityIndex = map['priorityIndex'] as int;

    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      isCompleted: (map['isCompleted'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      dueDate: DateTime.parse(map['dueDate'] as String),
      startTime: TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60),
      endTime: TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60),
      category: defaultCategories.firstWhere(
        (cat) => cat.name == categoryName,
        orElse: () => defaultCategories.first,
      ),
      priority: TaskPriority.values[priorityIndex],
      ownerEmail: map['ownerEmail'] as String?,
    );
  }
}
