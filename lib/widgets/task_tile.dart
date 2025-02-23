import 'package:flutter/material.dart';
import '../models/task_model.dart';

/// A stateless widget that represents a single task item in a list.
class TaskTile extends StatelessWidget {
  /// The task data to be displayed.
  final Task task;

  /// Callback function triggered when the task's completion status is toggled.
  final VoidCallback onToggle;

  /// Callback function triggered when the task is deleted.
  final VoidCallback onDelete;

  /// Constructor to initialize a `TaskTile` with required parameters.
  TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// Displays the task title with a strikethrough effect if completed.
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),

      /// Checkbox to indicate task completion, calling `onToggle` when changed.
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) => onToggle(),
      ),

      /// Delete button represented by a red trash icon, calling `onDelete` when pressed.
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
