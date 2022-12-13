import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(LocationDenied('not able to acess'));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationDenied('denied'));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(LocationDenied('denied forever'));
    }
    Position currenPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('lat' + currenPosition.latitude.toString());
    print('log' + currenPosition.longitude.toString());
    emit(LocationAcessed(currenPosition.latitude.toString(),
        currenPosition.longitude.toString()));
        
      
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
