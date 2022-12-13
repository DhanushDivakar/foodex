part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationAcessed extends LocationState {
  final String? latitude;
  final String? longitude;
  const LocationAcessed(this.latitude, this.longitude);
}

class LocationDenied extends LocationState {
  final String? error;
 const  LocationDenied(this.error);
}
