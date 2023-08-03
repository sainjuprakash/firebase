import 'package:firebase/model/common_state.dart';
import 'package:firebase/model/post.dart';
import 'package:firebase/services/crud_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final crudProvider = StateNotifierProvider<CrudProvider, CommonState>(
        (ref) => CrudProvider(CommonState(
      isLoad: false,
      isSuccess: false,
      isError: false,
      errText: '',
    )));

class CrudProvider extends StateNotifier<CommonState> {
  CrudProvider(super.state);

  Future<void> addPost(
      {required String title,
      required String detail,
      required String userID,
      required XFile image}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response = await CrudService.addPost(
        title: title, detail: detail, userID: userID, image: image);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }

  Future<void> deletePost(
      {required String postId, required String imageId}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response =
        await CrudService.deletePost(postId: postId, imageId: imageId);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }

  Future<void> updatePost(
      {required String title,
      required String detail,
      required String postId,
      XFile? image,
      String? imageId}) async {
    state = state.copyWith(
        errText: '', isError: false, isLoad: true, isSuccess: false);
    final response = await CrudService.updatePost(
        title: title, detail: detail, postId: postId,image: image, imageId: imageId);
    response.fold((l) {
      state = state.copyWith(
          errText: l, isError: true, isLoad: false, isSuccess: false);
    },
        (r) => {
              state = state.copyWith(
                  errText: '', isError: false, isLoad: false, isSuccess: r)
            });
  }

  Future<void> likePost(
      {
        required String username,
        required String postId,
        required int like
      }) async {
    state = state.copyWith(errText: '',isError: false, isSuccess: false, isLoad: true);
    final response = await CrudService.likePost(username: username, postId: postId, like: like);
    response.fold((l) {
      state = state.copyWith(errText: l,isError: true, isSuccess: false, isLoad: false);
    }, (r) {
      state = state.copyWith(errText: '',isError: false, isSuccess: r, isLoad: false);
    });
  }

  Future<void> addComment(
      {
        required Comment comment,
        required String postId,
      }) async {
    state = state.copyWith(errText: '',isError: false, isSuccess: false, isLoad: true);
    final response = await CrudService.addComment(comment: comment, postId: postId);
    response.fold((l) {
      state = state.copyWith(errText: l,isError: true, isSuccess: false, isLoad: false);
    }, (r) {
      state = state.copyWith(errText: '',isError: false, isSuccess: r, isLoad: false);
    });
  }

}



