import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/authentication.dart';
import 'package:todo_app/services/todo.dart';
import 'package:todo_app/todos/todos.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameField = TextEditingController();

  final passwordField = TextEditingController();

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to ToDo App'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(
            RepositoryProvider.of<AuthenticationServices>(context),
            RepositoryProvider.of<TodoService>(context))
          ..add(RegisterServicesEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessfulLoginState) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TodosPage(username: state.username)));
            }
            if (state is HomeInitial) {
              if (state.error != null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(state.error!),
                        ));
              }
            }
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: TextField(
                      textAlign: TextAlign.left,
                      style:
                          const TextStyle(fontSize: 25, color: Colors.black87),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        fillColor: Color.fromARGB(255, 235, 233, 233),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      controller: usernameField,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: TextField(
                      textAlign: TextAlign.left,
                      style:
                          const TextStyle(fontSize: 25, color: Colors.black87),
                      obscureText: isHidden,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Color.fromARGB(255, 235, 233, 233),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                        ),
                      ),
                      controller: passwordField,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => BlocProvider.of<HomeBloc>(context)
                              .add(LoginEvent(usernameField.text.trim(),
                                  passwordField.text)),
                          child: const Text('Login'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 26, 153, 75),
                            onPrimary: Color.fromARGB(255, 248, 235, 235),
                            // onSurface: Color.fromARGB(240, 52, 70, 151),
                            textStyle: const TextStyle(fontSize: 20),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<HomeBloc>(context).add(
                                RegisterAccountEvent(usernameField.text.trim(),
                                    passwordField.text));
                          },
                          child: const Text('Register'),
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 26, 153, 75),
                              onPrimary: Color.fromARGB(255, 248, 235, 235),
                              textStyle: const TextStyle(
                                fontSize: 20,
                              )),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            String name = usernameField.text;
                            print(name.trim() + 'A');
                          }),
                          child: Text('Print'))
                    ],
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
