import 'package:flutter/material.dart';
import '../models/task_model.dart';

class PriorityScreen extends StatefulWidget {
  final Task task;
  final Function(String) onPrioritySelected;

  PriorityScreen({required this.task, required this.onPrioritySelected});

  @override
  _PriorityScreenState createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {
  String _selectedPriority = "low"; // Default priority

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.task.priority; // Load current priority
  }

  void _setPriority(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
    widget.onPrioritySelected(priority);
    Navigator.pop(context); // Return to HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set Priority")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Select Priority for Task: ${widget.task.title}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text("Low"),
            leading: Radio(
              value: "low",
              groupValue: _selectedPriority,
              onChanged: (value) => _setPriority(value!),
            ),
          ),
          ListTile(
            title: Text("Medium"),
            leading: Radio(
              value: "medium",
              groupValue: _selectedPriority,
              onChanged: (value) => _setPriority(value!),
            ),
          ),
          ListTile(
            title: Text("High"),
            leading: Radio(
              value: "high",
              groupValue: _selectedPriority,
              onChanged: (value) => _setPriority(value!),
            ),
          ),
        ],
      ),
    );
  }
}
