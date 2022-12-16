import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/cubit/get_data_state.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class GetDataCubit extends Cubit<GetDataState> {
  GetDataCubit() : super(const GetDataState());

  void getFireData(Location position) async {
    final geo = Geoflutterfire();
    GeoFirePoint mylocation = geo.point(
        latitude: position.latitude,
        longitude: position
            .longitude); // GeoFirePoint(position.latitude, position.longitude);
    var collectionRef = FirebaseFirestore.instance.collection('user');
    double radius = 10;
    String field = 'locationCoords';

    final _firestore = FirebaseFirestore.instance;

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionRef)
        .within(center: mylocation, radius: radius, field: field);
  }

  void getFirestoreData(Location position) async {
    emit(state.copyWith(isLoading: true));
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double distance = 1000 * 0.000621371 ;
    double lowerLat = position.latitude - (lat * distance);
    double lowerLon = position.longitude - (lon * distance);
    double greaterLat = position.latitude + (lat * distance);
    double greaterLon = position.longitude + (lon * distance);
    // print(greaterLat);
    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    var data = await FirebaseFirestore.instance
        .collection('user')
        .where("locationCoords", isGreaterThan: lesserGeopoint)
        .where("locationCoords", isLessThan: greaterGeopoint)
        .get();

        //print(data);
    var firedata = data.docs
        .map(
          (e) => GetData(
            location: e.data()['locationCoords'],
            image: e.data()['image'],
            title: e.data()['title'],
            description: e.data()['description'],
          ),
        )
        .toList();

    data.docs;

    print(firedata);
    print(data.docs);

    emit(
      state.copyWith(isLoading: false, getData: firedata, error: 'error'),
    );
  }
}
