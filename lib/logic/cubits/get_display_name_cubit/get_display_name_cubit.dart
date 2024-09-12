import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'get_display_name_state.dart';

class GetDisplayNameCubit extends Cubit<GetDisplayNameState> {
  GetDisplayNameCubit() : super(GetDisplayNameInitialState(isLoading: false));

  void getDisplayName() async {
    emit(GetDisplayNameLoadingState(isLoading: true));

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final username = user.displayName ?? 'User';
        emit(GetDisplayNameSuccessState(username: username, isLoading: false));
      } else {
        emit(GetDisplayNameFailureState(isLoading: false));
      }
    } catch (e) {
      emit(GetDisplayNameFailureState(isLoading: false));
    }
  }
}
