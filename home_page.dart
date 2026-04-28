import 'package:bang_test/datbase/database.dart';
import 'package:bang_test/pages/todo_tile.dart';
import 'package:bang_test/util/dialoge.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (_mybox.get('TODOLIST') == null) {
      db.createInitData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  final _textEditingController = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_textEditingController.text, false]);
      _textEditingController.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void createDialoge() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogeBox(
          controller: _textEditingController,
          onSave: saveNewTask,
          onCancel: Navigator.of(context).pop,
        );
      },
    );
  }

  void removeTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text("TO DO "),
        backgroundColor: Colors.orange[300],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDialoge(),
        backgroundColor: Colors.orange[300],
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.toDoList[index][0],
            taskComplete: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (value) => removeTask(index),
          );
        },
      ),
    );
  }
}
