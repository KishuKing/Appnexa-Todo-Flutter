import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class LocalStorage {
  static const String _key = "tasks";

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) return [];

    return jsonList.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }
}
