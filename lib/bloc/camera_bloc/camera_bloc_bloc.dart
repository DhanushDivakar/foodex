import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:'

part 'camera_bloc_event.dart';
part 'camera_bloc_state.dart';

class CameraCubit extends Cubit<String?> {
  CameraCubit() : super(null);

  void getImage(ImageSource fileSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: fileSource);
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