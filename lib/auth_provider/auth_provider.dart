import 'package:firebase/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/common_state.dart';

final authProvider = StateNotifierProvider<AuthProvider, CommonState>(
    (ref) => AuthProvider(CommonState(
          isLoad: false,
          isSuccess: false,
          isError: false,
          errText: '',
        )));

class AuthProvider extends StateNotifier<CommonState> {
  AuthProvider(super.state);

  Future<void> userLogin(
      {required String email, required String password}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response =
        await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }

  Future<void> userRegister(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response =
        await AuthService.userRegister(
            email: email, password: password, username: username, image: image);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }
  Future<void> userLogOut() async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response =
    await AuthService.userLogOut();
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
            (r) => {
          state = state.copyWith(
              errText: '', isError: false, isLoad: false, isSuccess: r)
        });
  }

}
