import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class TaskDatabase {
  TaskDatabase._();

  static final TaskDatabase instance = TaskDatabase._();
  static const String _webTasksKey = 'web_tasks';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'todo_tasks.db');
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            createdAt TEXT NOT NULL,
            dueDate TEXT NOT NULL,
            startMinutes INTEGER NOT NULL,
            endMinutes INTEGER NOT NULL,
            categoryName TEXT NOT NULL,
            priorityIndex INTEGER NOT NULL,
            ownerEmail TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS tasks');
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              isCompleted INTEGER NOT NULL,
              createdAt TEXT NOT NULL,
              dueDate TEXT NOT NULL,
              startMinutes INTEGER NOT NULL,
              endMinutes INTEGER NOT NULL,
              categoryName TEXT NOT NULL,
              priorityIndex INTEGER NOT NULL,
              ownerEmail TEXT NOT NULL
            )
          ''');
        }
      },
    );

    return _database!;
  }

  Future<List<Task>> _getAllWebTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonText = prefs.getString(_webTasksKey);
    if (jsonText == null || jsonText.isEmpty) return [];

    final List<dynamic> data = jsonDecode(jsonText) as List<dynamic>;
    return data
        .map((item) => Task.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<int> insertTask(Task task) async {
    if (kIsWeb) {
      final tasks = await _getAllWebTasks();
      final nextId = tasks.isEmpty
          ? 1
          : tasks.map((task) => task.id ?? 0).reduce((a, b) => a > b ? a : b) +
                1;

      task.id = nextId;
      tasks.add(task);
      await _saveWebTasks(tasks);
      return nextId;
    }

    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks(String ownerEmail) async {
    if (kIsWeb) {
      final allTasks = await _getAllWebTasks();
      final userTasks = allTasks.where((t) => t.ownerEmail == ownerEmail).toList();
      userTasks.sort(
        (a, b) =>
            a.startTime.hour * 60 +
            a.startTime.minute -
            (b.startTime.hour * 60 + b.startTime.minute),
      );
      return userTasks;
    }

    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'ownerEmail = ?',
      whereArgs: [ownerEmail],
      orderBy: 'startMinutes ASC',
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    if (kIsWeb) {
      final tasks = await _getAllWebTasks();
      final index = tasks.indexWhere((item) => item.id == task.id);
      if (index == -1) return 0;

      tasks[index] = task;
      await _saveWebTasks(tasks);
      return 1;
    }

    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    if (kIsWeb) {
      final tasks = await _getAllWebTasks();
      final oldLength = tasks.length;
      tasks.removeWhere((task) => task.id == id);
      await _saveWebTasks(tasks);
      return oldLength - tasks.length;
    }

    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _saveWebTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonText = jsonEncode(tasks.map((task) => task.toMap()).toList());
    await prefs.setString(_webTasksKey, jsonText);
  }
}
