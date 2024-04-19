import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider/Models/task.dart';
import 'package:todo_provider/provider/todo.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  DateTime date = DateTime.now();

  TextEditingController control = TextEditingController();
  //TextEditingController control2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.loadTask();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 27),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Add Task",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              content: TextField(
                controller: control,
                decoration: InputDecoration(hintText: "Enter task name"),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                      todoProvider.addTask(
                        Task(
                          content: control.text,
                          completed: false,
                          time: DateTime.now(),
                        ),
                      );
                      todoProvider.saveTask();
                      control.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Add Task"))
              ],
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 43, left: 21, right: 21),
        child: Column(
          children: [
            Consumer<TodoProvider>(builder: (a, b, c) {
              return Column(
                children: [
                  tasks(
                    providerdata: todoProvider,
                    items: todoProvider.data.where((e) => e.completed).toList(),
                    works: 'Completed ToDos',
                  ),
                  tasks(
                    providerdata: todoProvider,
                    items:
                        todoProvider.data.where((e) => !e.completed).toList(),
                    works: 'Incompleted ToDos',
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

class tasks extends StatelessWidget {
  const tasks({
    super.key,
    required this.works,
    required this.items,
    required this.providerdata,
  });

  final String works;
  final List<Task> items;
  final TodoProvider providerdata;

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                works,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 150, 19, 226),
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete ToDo"),
                          content: Text(
                              "Are you sure you want to delete this ToDo?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                providerdata
                                    .removeTask(providerdata.data[index]);
                                Navigator.pop(context);
                                providerdata.saveTask();
                              },
                              child: Text("Delete"),
                            )
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(11),
                              Text(items[index].content,
                                  style: items[index].completed
                                      ? TextStyle(
                                          fontSize: 19,
                                          decoration:
                                              TextDecoration.lineThrough)
                                      : TextStyle(fontSize: 19)),
                              Text(
                                  "Added:${DateFormat('dd/MM/yyyy HH:mm a').format(items[index].time)}"),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: items[index].completed,
                                onChanged: (value) {
                                  providerdata.updateTask(items[index]);

                                  providerdata.saveTask();
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  providerdata.removeTask(items[index]);
                                  providerdata.saveTask();
                                },
                                child: Icon(Icons.clear_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 22,
                      ),
                  itemCount: items.length),
            ],
          );
  }
}
