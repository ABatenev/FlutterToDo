import 'package:flutter/material.dart';

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final dynamic onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.lineThrough
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      }, 
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo лист")
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        children: _todos.map((Todo todo) =>
          TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange
          )
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: "Добавить",
        child: const Icon(Icons.add)),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textEditingController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Добавить новую задачу"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Введите задачу"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Добавить'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textEditingController.text);
              },
            )
          ],
        );
      },
    );
  }
}

class TodoApp extends StatelessWidget{
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo list',
      home: TodoList()
    );
  }
}

void main() => runApp(const TodoApp());
