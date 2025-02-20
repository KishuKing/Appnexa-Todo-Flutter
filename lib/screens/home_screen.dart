import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/local_storage.dart';
import '../widgets/task_tile.dart';
import 'priority_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];
  List<Task> _allTasks = []; // Store all tasks for search
  final LocalStorage _storage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _loadTasks() async {
    List<Task> loadedTasks = await _storage.loadTasks();
    setState(() {
      _tasks = loadedTasks;
      _allTasks = List.from(loadedTasks); // Copy for search
    });
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        Task newTask = Task(title: _taskController.text);
        _tasks.add(newTask);
        _allTasks.add(newTask);
      });
      _storage.saveTasks(_tasks);
      _taskController.clear();
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _storage.saveTasks(_tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      Task taskToDelete = _tasks[index];
      _tasks.removeAt(index);
      _allTasks.remove(taskToDelete);
    });
    _storage.saveTasks(_tasks);
  }

  void _setPriority(int index, String priority) {
    setState(() {
      _tasks[index].priority = priority;
    });
    _storage.saveTasks(_tasks);
  }

  void _openPriorityScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PriorityScreen(
              task: _tasks[index],
              onPrioritySelected: (priority) {
                _setPriority(index, priority);
              },
            ),
      ),
    );
  }

  void _searchTask(String query) {
    setState(() {
      if (query.isEmpty) {
        _tasks = List.from(_allTasks);
      } else {
        _tasks =
            _allTasks
                .where(
                  (task) =>
                      task.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taskify"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TaskSearch(_allTasks));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🟢 Add Task Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // 🟢 TextField for entering tasks
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: "New Task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // 🟢 Rectangular "Add" button with same height as TextField
                SizedBox(
                  height: 56, // Set the same height as TextField
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ), // Remove button roundness
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ), // Adjust padding
                    ),
                    onPressed: _addTask,
                    child: Text("Add"),
                  ),
                ),
              ],
            ),
          ),

          // 🟢 Task List
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: _tasks[index],
                  onToggle: () => _toggleTask(index),
                  onDelete: () => _deleteTask(index),
                  onTap: () => _openPriorityScreen(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TaskSearch extends SearchDelegate {
  final List<Task> tasks;

  TaskSearch(this.tasks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        tasks
            .where(
              (task) => task.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(results[index].title));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
