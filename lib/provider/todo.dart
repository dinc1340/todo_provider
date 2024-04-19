import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_provider/Models/task.dart';

class TodoProvider extends ChangeNotifier {
  List<Task> data = [];
  void addTask(Task value) {
    data.add(value);
    notifyListeners();
  }

  void removeTask(Task value) {
    data.remove(value);
    notifyListeners();
  }

  void updateTask(Task value) {
    value.completeData();
    notifyListeners();
  }

  saveTask() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> anthk = data
        .map((item) => '${item.content},${item.time},${item.completed}')
        .toList();
    pref.setStringList("todo", anthk);
  }

  void loadTask() async {
    SharedPreferences load = await SharedPreferences.getInstance();
    List<String> shahul = load.getStringList("todo") ?? [];
    if (shahul.isNotEmpty) {
      data = shahul.map((item) {
        List<String> parts = item.split(',');
        return Task(
            content: parts[0],
            completed: parts[2] == 'true' ? true : false,
            time: DateTime.parse(parts[1]));
      }).toList();
    }
    notifyListeners();
  }
}
