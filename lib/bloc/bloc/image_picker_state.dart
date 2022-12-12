part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();
  
  @override
  List<Object> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class CameraReady extends ImagePickerState{}

class CameraFailure extends ImagePickerState{
  final String error;
  const CameraFailure({this.error = 'CameraFailure'});

  @override
  List<Object> get props => [error];
}

class CameraCaptureInProgress extends ImagePickerState{}

class CameraCaptureSuccess extends ImagePickerEvent{
  final String path;
  const CameraCaptureSuccess(this.path);
}


class CameraCaptureFailure extends ImagePickerEvent{
  final String error;
  const CameraCaptureFailure({this.error = 'CameraFailure'});

  @override
  List<Object> get props => [error];
}
