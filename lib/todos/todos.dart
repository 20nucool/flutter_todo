import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/todo.dart';
import 'package:todo_app/todos/bloc/todos_bloc.dart';

class TodosPage extends StatelessWidget {
  final String username;

  const TodosPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: BlocProvider(
        create: (context) =>
            TodosBloc(RepositoryProvider.of<TodoService>(context))
              ..add(LoadTodosEvent(username)),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              return ListView(children: [
                ...state.tasks.map(
                  (e) => ListTile(
                    title: Text(e.task),
                    trailing: Checkbox(
                        value: e.completed,
                        onChanged: (val) {
                          BlocProvider.of<TodosBloc>(context)
                              .add(ToggleTodoEvent(e.task));
                        }),
                  ),
                ),
                ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Create new task'),
                      Icon(Icons.add),
                    ],
                  ),
                  // trailing: Icon(Icons.create),
                  onTap: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) => Dialog(child: CreateNewTask()));
                    if (result != null) {
                      BlocProvider.of<TodosBloc>(context)
                          .add(AddTodoEvent(result));
                    }
                  },
                )
              ]);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('What task do you want to create?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25, color: Color.fromARGB(255, 94, 60, 94))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.black87, fontSize: 20),
            decoration: const InputDecoration(
              labelText: 'New Task',
            ),
            controller: _inputController,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 26, 153, 75),
              onPrimary: const Color.fromARGB(255, 248, 235, 235),
              // onSurface: Color.fromARGB(240, 52, 70, 151),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              if (_inputController.text.trim() == null) {
                return;
              }
              if (_inputController.text.trim() != null) {
                Navigator.of(context).pop(_inputController.text);
              }
            },
            child: const Text('SAVE')),
      ]),
    );
  }
}
