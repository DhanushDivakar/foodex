import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void getCurrentPosition() async {
    //permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('permission denied');
      emit(const LocationDenied('permission denied'));
    } else {
      Position currenPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
          print('lat'  + currenPosition.latitude.toString());
          print('log' + currenPosition.longitude.toString());
          emit(LocationAcessed(currenPosition.latitude.toString(), currenPosition.longitude.toString()));
    }
  }
}
