import 'package:flutter/material.dart';

import 'api.dart';

class Todo {
  Todo(
      {required this.id,
      required this.name,
      required this.checked,
      required this.createdAt});
  final int id;
  final String name;
  bool checked;
  String createdAt;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        name: json['name'],
        id: json['id'],
        checked: json['isComplete'],
        createdAt: json['createdAt']);
  }
}

class TodoItem extends StatelessWidget {
  TodoItem({required this.todo, required this.onTodoChanged})
      : super(key: ObjectKey(todo));

  final Todo todo;
  final dynamic onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
        color: Colors.black, decoration: TextDecoration.lineThrough);
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

  late Future<List<Todo>> todos;

  @override
  void initState() {
    super.initState();
    todos = fetchToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo лист")),
      body: FutureBuilder(
          future: todos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  children: snapshot.data!
                      .map((Todo todo) => TodoItem(
                          todo: todo, onTodoChanged: _handleTodoChange))
                      .toList());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: "Добавить",
          child: const Icon(Icons.add)),
    );
  }

  void _handleTodoChange(Todo todo) async {
    await updateToDo(todo.id);
    var futerTodos = fetchToDos();
    setState(() {
      todos = futerTodos;
    });
  }

  void _removeTodo(Todo todo) async {
    await deleteToDo(todo.id);
    var futerTodos = fetchToDos();
    setState(() {
      todos = futerTodos;
    });
  }

  void _addTodoItem(String name) async {
    await createToDo(name);
    var futerTodos = fetchToDos();
    setState(() {
      todos = futerTodos;
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

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Todo list', home: TodoList());
  }
}
