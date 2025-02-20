class Task {
  String title;
  bool isCompleted;
  String priority; // New field for priority

  Task({required this.title, this.isCompleted = false, this.priority = "low"});

  Map<String, dynamic> toJson() => {
    'title': title,
    'isCompleted': isCompleted,
    'priority': priority,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      priority: json['priority'] ?? "low", // Default priority if not set
    );
  }
}
