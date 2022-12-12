part of 'camera_bloc_bloc.dart';

@immutable
abstract class CameraBlocEvent {}

class CameraOpen extends CameraBlocEvent {}

class CameraFromGallery extends CameraBlocEvent {}
