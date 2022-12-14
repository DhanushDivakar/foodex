
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:'

part 'camera_bloc_event.dart';
part 'camera_bloc_state.dart';

class CameraCubit extends Cubit<String?> {
  CameraCubit() : super(null);

  void getImage(ImageSource fileSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: fileSource, imageQuality: 10);
    if (pickedFile == null) {
      return;
    }
    // print(pickedFile?.path);
    emit(pickedFile.path);
  }

  void resetImage() {
    emit(null);
  }

  @override
  void onChange(Change<String?> change) {
    super.onChange(change);
    debugPrint(change.currentState);
    debugPrint(change.nextState);
  }
}
