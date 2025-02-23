import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

/// Class responsible for storing and retrieving tasks using local storage.
class LocalStorage {
  static const String _key =
      "tasks"; // Key used to store tasks in SharedPreferences.

  /// Saves a list of tasks to local storage.
  /// Each task is converted to a JSON string before being stored.
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  /// Loads a list of tasks from local storage.
  /// The stored JSON strings are converted back to Task objects.
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) return [];

    return jsonList.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }
}
