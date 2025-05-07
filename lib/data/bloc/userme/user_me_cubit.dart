import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/user_model.dart';
import '../../network/user_me.dart';

part 'user_me_state.dart';

class UserMeCubit extends Cubit<UserMeState> {
  final UserMeRequest userMeRequest;

  UserMeCubit(this.userMeRequest) : super(UserMeInitial());

  Future<void> fetchUserMe() async {
    emit(UserMeLoading());
    try {
      final userMe = await userMeRequest.request();
      emit(UserMeData(userMe));
    } catch (e) {
      emit(UserMeError(e.toString()));
    }
  }

  int? getUserId() {
    if (state is UserMeData) {
      return (state as UserMeData).userMe.id;
    }
    return null;
  }
}
