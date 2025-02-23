import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/local_storage.dart';
import '../widgets/task_tile.dart';

/// The main screen of the app where users can add, delete, and search for tasks.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for handling text input in the task input field
  final TextEditingController _taskController = TextEditingController();

  // List of tasks displayed on the screen
  List<Task> _tasks = [];

  // A separate list to store all tasks, used for search functionality
  List<Task> _allTasks = [];

  // Local storage instance to save and load tasks
  final LocalStorage _storage = LocalStorage();

  /// Initializes the screen and loads tasks from local storage.
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Disposes of the text controller when the widget is removed from the widget tree.
  @override
  void dispose() {
    _taskController.dispose(); // Prevents memory leaks
    super.dispose();
  }

  /// Loads tasks from local storage and updates the UI.
  void _loadTasks() async {
    List<Task> loadedTasks = await _storage.loadTasks();
    setState(() {
      _tasks = loadedTasks;
      _allTasks = List.from(
        loadedTasks,
      ); // Creates a copy to preserve original data
    });
  }

  /// Adds a new task to the list and saves it in local storage.
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        Task newTask = Task(title: _taskController.text);
        _tasks.add(newTask); // Adds task to the displayed list
        _allTasks.add(newTask); // Adds task to the search list
      });
      _storage.saveTasks(_tasks); // Saves tasks to local storage
      _taskController.clear(); // Clears the input field after adding a task
    }
  }

  /// Toggles the completion status of a task and saves the updated list.
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _storage.saveTasks(_tasks);
  }

  /// Deletes a task from the list and updates local storage.
  void _deleteTask(int index) {
    setState(() {
      Task taskToDelete = _tasks[index];
      _tasks.removeAt(index); // Removes task from the displayed list
      _allTasks.remove(taskToDelete); // Also removes it from the search list
    });
    _storage.saveTasks(_tasks); // Saves the updated list to local storage
  }

  /// Builds the UI for the home screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Taskify")),
      body: Column(
        children: [
          // Task input field with an "Add" button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: "New Task",
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask, // Calls _addTask() when clicked
                ),
              ),
            ),
          ),
          // List of tasks displayed using a ListView
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: _tasks[index],
                  onToggle: () => _toggleTask(index), // Toggles task completion
                  onDelete: () => _deleteTask(index), // Deletes the task
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
