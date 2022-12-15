import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/cubit/get_data_state.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';

class GetDataCubit extends Cubit<GetDataState> {
  GetDataCubit() : super(const GetDataState());

  void getFirestoreData(Location position) async {
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double distance = 1000 * 0.000621371;
    double lowerLat = position.latitude - (lat * distance);
    double lowerLon = position.longitude - (lon * distance);
    double greaterLat = position.latitude + (lat * distance);
    double greaterLon = position.longitude + (lon * distance);
    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
  var data =  await FirebaseFirestore.instance
        .collection('user')
        .where("locationCoords", isGreaterThan: lesserGeopoint)
        .where("locationCoords", isLessThan: greaterGeopoint)
        .get();

 data.docs;

 print(data);




    emit(state.copyWith(
        isLoading: false,
        getData:  GetData(location: position),
        error: ''));
  }
}
