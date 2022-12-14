import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState()) {
    getCurrentPosition();
  }

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    emit(state.copyWith(isLoading: true));

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    try {
      if (!serviceEnabled) {
        emit(state.copyWith(
            isLoading: false, error: 'service is not available!'));
        //emit(LocationDenied('not able to acess'));
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(
              isLoading: false,
              error: 'please turn on location',
              permission: LocationPermission.denied));
        }
      } else if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
            isLoading: false,
            error: 'please turn on location',
            permission: LocationPermission.deniedForever));

        await Geolocator.openLocationSettings();
      }
      Position currenPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('lat ${currenPosition.latitude}');
      print('log ${currenPosition.longitude}');
      emit(
        state.copyWith(
          isLoading: false,
          permission: LocationPermission.whileInUse,
          location: Location(
            latitude: currenPosition.latitude,
            longitude: currenPosition.longitude,
          ),
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false));
    }
  }

  //permission
  //    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if(!serviceEnabled){
  //     return Future.error('Location sevices are disabled');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     print('permission denied');
  //     emit(const LocationDenied('permission denied'));
  //   } else {
  //     Position currenPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //         print('lat'  + currenPosition.latitude.toString());
  //         print('log' + currenPosition.longitude.toString());
  //         emit(LocationAcessed(currenPosition.latitude.toString(), currenPosition.longitude.toString()));
  //   }
  // }
}
