import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/auth_cubit.dart';
import 'package:foodex/bloc/cubit/get_data_cubit.dart';
import 'package:foodex/bloc/cubit/get_data_state.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:foodex/screens/modal_bottom_sheet.dart';

import 'package:foodex/screens/sign_in_screen.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final position = context.read<LocationCubit>().state.location;
    final geo = Geoflutterfire();
    GeoFirePoint mylocation =
        geo.point(latitude: position.latitude, longitude: position.longitude);
    var collectionRef = FirebaseFirestore.instance.collection('user');
    double radius = 1;
    String field = 'locationCoords';
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionRef)
        .within(
            center: mylocation, radius: radius, field: field, strictMode: true);
    // List<Location> polyLinesLatLongs ;
    //   FirebaseFirestore.instance.collection('user').get().then((value) {
    //   var firebase = value.docs;
    //   for(var i =1; i<firebase.length; i++){
    //     GeoPoint point = firebase[i]['locationCoords']['geopoint'];
    //   //  polyLinesLatLongs.add(Location(latitude: ));

    //   }

    // });
    // stream.listen((List<DocumentSnapshot> documentList) {
    //   // print(stream.length);
    //   print('Here');
    //   print(documentList.isEmpty);
    // });

    // context.read<LocationCubit>().getCurrentPosition();
    // print(position.latitude);
    context.read<GetDataCubit>().getFirestoreData(
        Location(latitude: position.latitude, longitude: position.longitude));
    var snap =
        FirebaseFirestore.instance.collection('user').doc('a').snapshots();
    print(snap);

    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // print(uid);
  }

  @override
  Widget build(BuildContext context) {
    //final positionn = context.read<LocationCubit>().state.location;
    // GeoFirePoint(position.latitude, position.longitude);

    //final _firestore = FirebaseFirestore.instance;
    final position = context.read<LocationCubit>().state.location;
    final geo = Geoflutterfire();
    GeoFirePoint mylocation =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    context.read<GetDataCubit>().getFirestoreData(position);
    var collectionRef = FirebaseFirestore.instance.collection('user');
    double radius = 1000;
    String field = 'locationCoords';
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionRef)
        .within(
            center: mylocation, radius: radius, field: field, strictMode: true);

    GeoFirePoint point = Geoflutterfire()
        .point(latitude: position.latitude, longitude: position.longitude);
    //double distance = 30;
    Stream<List<DocumentSnapshot>> streamm = geo
        .collection(collectionRef: collectionRef)
        .within(center: point, radius: radius, field: field);
    streamm.listen((List<DocumentSnapshot> documentList) {
      //print(stream.length);
      if (documentList.isEmpty) {
        //print('empty');

        /// print(documentList[0].data());
      }
      //print('Here');
      // print(documentList[1].data());
    });

//     List Data = [];

//     print('hiii');
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//      final pos = context.read<LocationCubit>().state.location;
//      final lati = pos.latitude;
//      final long = pos.longitude;

//     double lat = 0.0144927536231884;
//     double lon = 0.0181818181818182;
//     double distance = 1000 * 0.000621371;
//    // var position = context.read<LocationCubit>().state.location;
//     double lowerLat = position.latitude - (lat * distance);
//     double lowerLon = position.longitude - (lon * distance);
//     double greaterLat = position.latitude + (lat * distance);
//     double greaterLon = position.longitude + (lon * distance);
//     GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
//     GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
//  var querySnapshot =  FirebaseFirestore.instance.collection('user')
//     .where("locationCoords", isGreaterThan: lesserGeopoint)
//     .where("locationCoords", isLessThan: greaterGeopoint)
//     .limit(100)
//     .get().then((QuerySnapshot value) {
//       value.docs.forEach((element) {
//         return Data.add(element.data());

//       });
//     });
//     print(Data);

    return Scaffold(
      appBar: AppBar(
        title: BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state.permission == LocationPermission.denied ||
                state.permission == LocationPermission.deniedForever) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Turn on Location'),
                ),
              );
            }
          },
          child: const Text('Foodex'),
        ),
        actions: [
          TextButton(
            onPressed: (() => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).logOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignInScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Ok',
                          ),
                        ),
                      ],
                    );
                  },
                )),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),

            //   // BlocProvider.of<AuthCubit>(context).logOut();
            //   // // Navigator.pushReplacement(
            //   // //   context,
            //   // //   MaterialPageRoute(
            //   // //     builder: (context) => SignInScreen(),
            //   // //   ),
            //   // // );
            // },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),

              //       stream:FirebaseFirestore.instance.collection('user').collection(collectionRef: collectionRef)
              // .within(center: mylocation, radius: radius, field: field, strictMode: true),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs ?? [];
                // print('nnh');
                // print(data);

                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      // print(data[index]['title']);

                      // print('object');

                      return ListTile(
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            data[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          data[index]['title'],
                        ),
                        subtitle: Text(data[index]['description']),
                      );
                    },
                  ),
                );
              },
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      double distanceInMeters = Geolocator.distanceBetween(
                          position.latitude,
                          position.longitude,
                         double.parse(data[index]['latitude']) ,
                          double.parse(data[index]['longitude']));
                      print(distanceInMeters);
                      //13.1673192
                      //77.6358929

                      return Text(data[index]['latitude']);
                    },
                  ),
                );
              },
            ),
            BlocBuilder<GetDataCubit, GetDataState>(builder: (context, state) {
              // Location location = context.read<LocationCubit>().state.location;
              //final data = context.read<GetDataCubit>().state.getData;
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // if (state.error == null) {
              //   print('error');
              // }
              return Expanded(
                child: ListView.builder(
                  itemCount: state.getData.length,
                  itemBuilder: (context, index) {
                    final data = state.getData[0];
                    // print( data);
                    print(data.description);
                    print(data.title);
                    return ListTile(
                      //leading: Image.network(data.image),
                      title: Text(
                        data.title,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(data.description),
                    );
                  },
                ),
              );
              // return ListTile(
              //  title: state.getData ,
              // );
            }),

            // Image.network(
            //   'https://images.pexels.com/photos/14610789/pexels-photo-14610789.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            //   // errorBuilder: (context, error, stackTrace) => Center(
            //   //   child: CircularProgressIndicator(),
            //   // ),
            //   loadingBuilder: (context, child, loadingProgress) => Center(
            //     child: Text('Loading')

            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: const ShowModalSheet(),
      // SingleChildScrollView(
      //   child: BlocConsumer<CameraCubit, String?>(
      //     listener: (context, state) {
      //       final imageCubit = BlocProvider.of<CameraCubit>(context);
      //       if (state == null) {
      //         const SnackBar(
      //           content: Text('Error'),
      //         );
      //         imageCubit.resetImage();
      //       }
      //     },
      //     builder: (context, state) {
      //       return Center(
      //         child: Column(
      //           children: [
      //             if (state != null && state.isNotEmpty)
      //               Image.file(File(state)),
      //             ElevatedButton(
      //               onPressed: () {
      //                 BlocProvider.of<CameraCubit>(context)
      //                     .getImage(ImageSource.camera);
      //               },
      //               child: const Text('Camera'),
      //             ),
//hiii
      //             ElevatedButton(
      //               onPressed: () {
      //                 BlocProvider.of<CameraCubit>(context)
      //                     .getImage(ImageSource.gallery);
      //               },
      //               child: const Text('Gallery'),
      //             ),

      //             BlocBuilder<LocationCubit, LocationState>(
      //               builder: (context, state) {
      //                 return Column(
      //                   children: [
      //                     if (state is LocationAcessed)
      //                       Column(
      //                         children: [
      //                           Text(state.latitude!),
      //                           Text(state.longitude!),
      //                         ],
      //                       ),
      //                     if (state is LocationDenied) Text(state.error!),
      //                     ElevatedButton(
      //                         onPressed: () {
      //                           BlocProvider.of<LocationCubit>(context)
      //                               .getCurrentPosition();
      //                         },
      //                         child: const Text('get location')),
      //                   ],
      //                 );
      //               },
      //             ),

      //             // Image.file(File(state!)),
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
