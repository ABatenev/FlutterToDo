import 'dart:convert';

import 'package:http/http.dart' as http;

import 'todo_app.dart';

Future<List<Todo>> fetchToDos() async {
  final response = await http.get(Uri.parse('https://localhost:7210/ToDo'));

  final List<Todo> todos = <Todo>[];

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    for (var todo in jsonDecode(response.body)) {
      todos.add(Todo.fromJson(todo));
    }

    return todos;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<http.Response> createToDo(String name) {
  return http.post(
    Uri.parse('https://localhost:7210/ToDo'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(name),
  );
}

Future<http.Response> updateToDo(int id) {
  return http.patch(Uri.parse('https://localhost:7210/ToDo/$id'));
}

Future<http.Response> deleteToDo(int id) {
  return http.delete(Uri.parse('https://localhost:7210/ToDo/$id'));
}
