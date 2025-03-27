import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/auth_api.dart'; // Ensure this path is correct
import 'package:meta/meta.dart';

part 'auth_bloc_state.dart';

class AuthBlocCubit extends Cubit<AuthBlocState> {
  final AuthApiRequest apiRequest;

  AuthBlocCubit(this.apiRequest) : super(AuthBlocInitial());

  Future<void> login(String? login, String? password) async {
    emit(AuthLoading());
    try {
      final response = await apiRequest.request(login, password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
