import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/services/authentication.dart';
import 'package:todo_app/services/todo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationServices _auth;
  final TodoService _todo;

  HomeBloc(this._auth, this._todo) : super(RegisteringServiceState()) {
    on<LoginEvent>((event, emit) async {
      final user = await _auth.authenticateUser(event.username, event.password);
      if (user != null) {
        emit(SuccessfulLoginState(user));
        emit(HomeInitial());
      }
    });

    on<RegisterServicesEvent>((event, emit) async {
      await _auth.init();
      await _todo.init();

      emit(HomeInitial());
    });

    on<RegisterAccountEvent>(((event, emit) async {
      final result = await _auth.createUser(event.username, event.password);
      switch (result) {
        case UserCreationResult.success:
          emit(SuccessfulLoginState(event.username));
          emit(HomeInitial());
          break;
        case UserCreationResult.failure:
          emit(HomeInitial(error: " Theres been an error"));
          break;
        case UserCreationResult.alreadyExists:
          emit(HomeInitial(error: "User already exists"));
          // TODO: Handle this case.
          break;
      }
    }));
  }
}
