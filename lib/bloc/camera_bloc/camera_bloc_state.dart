part of 'camera_bloc_bloc.dart';

@immutable
abstract class CameraBlocState {}

class CameraBlocInitial extends CameraBlocState {}

class CameraOpened extends CameraBlocState {}

class CameraClosed extends CameraBlocState {}
