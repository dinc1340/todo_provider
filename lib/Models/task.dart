class Task {
  final String content;
  bool completed;
  final DateTime time;

  Task({
    required this.content,
    required this.completed,
    required this.time,
  });
  void completeData() {
    completed = !completed;
    
  }
  
}
