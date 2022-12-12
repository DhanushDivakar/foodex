import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
//import 'package:'

part 'camera_bloc_event.dart';
part 'camera_bloc_state.dart';

class CameraCubit extends Cubit<String?> {
  CameraCubit() : super('') {
    Future<void> getImage(ImageSource fileSource) async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: fileSource);
      emit(pickedFile?.path);
    }

    void resetImage(){
      emit('');
    }

    @override
    void onChange(Change<String?> change){
      super.onChange(change);
      debugPrint(change.currentState);
      debugPrint(change.nextState);
    }
  }
}
