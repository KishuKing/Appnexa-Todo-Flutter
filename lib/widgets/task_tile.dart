import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap; // New function for tapping task

  TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        "Priority: ${task.priority.toUpperCase()}",
        style: TextStyle(
          color:
              task.priority == "high"
                  ? Colors.red
                  : task.priority == "medium"
                  ? Colors.orange
                  : Colors.green,
        ),
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) => onToggle(),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: onTap, // Open priority screen on tap
    );
  }
}
