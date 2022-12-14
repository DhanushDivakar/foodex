part of 'location_cubit.dart';

// abstract
class LocationState extends Equatable {
  final Location location;
  final bool isLoading;
  final String? error;
  final LocationPermission permission;
  const LocationState(
      {this.location = const Location(),
      this.isLoading = false,
      this.error,
      this.permission = LocationPermission.unableToDetermine});

  /// copyWith
  LocationState copyWith({
    Location? location,
    bool? isLoading,
    String? error,
    LocationPermission? permission,
  }) =>
      LocationState(
        location: location ?? this.location,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
        permission: permission ?? this.permission,
      );

  @override
  List<Object?> get props => [location, isLoading, error, permission];
}

// class LocationError extends LocationState{
//   final String? error;
//   LocationError({this.error});
// }

// class LocationInitial extends LocationState {}

// class LocationAcessed extends LocationState {
//   final String? latitude;
//   final String? longitude;
//   const LocationAcessed(this.latitude, this.longitude);
// }

// class LocationDenied extends LocationState {
//   final String? error;
//  const  LocationDenied(this.error);
// }

class Location {
  const Location({this.latitude = 0.0, this.longitude = 0.0});
  final double latitude;
  final double longitude;
}
