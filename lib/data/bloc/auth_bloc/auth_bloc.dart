import 'package:bloc/bloc.dart';
import 'package:incasator/data/reporisitory/auth_Repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await repository.login(event.userName, event.password);
        emit(AuthData(
          response.token ?? "",
          response.message ?? "Unknown error",
        ));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
