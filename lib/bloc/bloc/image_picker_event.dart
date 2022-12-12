part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class CameratInitialized extends ImagePickerEvent{}

class CameraStopped extends ImagePickerEvent{}

class CameraCaptured extends ImagePickerEvent{}
