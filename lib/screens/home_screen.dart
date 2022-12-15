import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/auth_cubit.dart';
import 'package:foodex/bloc/cubit/get_data_cubit.dart';
import 'package:foodex/bloc/cubit/get_data_state.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:foodex/screens/modal_bottom_sheet.dart';

import 'package:foodex/screens/sign_in_screen.dart';
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
    context.read<LocationCubit>().getCurrentPosition();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // context.read<LocationCubit>().getCurrentPosition();

//     QuerySnapshot querySnapshot;
//     double lat = 0.0144927536231884;
// double lon = 0.0181818181818182;
// double distance = 1000*0.000621371;
// var position = context.read<LocationCubit>().state.location;
// double lowerLat = position.latitude - (lat * distance);
// double lowerLon = position.longitude - (lon * distance);
// double greaterLat = position.latitude + (lat * distance);
// double greaterLon = position.longitude + (lon * distance);
// GeoPoint lesserGeopoint = GeoPoint(lowerLat,lowerLon);
// GeoPoint greaterGeopoint = GeoPoint(greaterLat,greaterLon);
// querySnapshot =  FirebaseFirestore.instance.collection('user')
//     .where("livelocation", isGreaterThan: lesserGeopoint)
//     .where("livelocation", isLessThan: greaterGeopoint)
//     .limit(100)
//     .get();

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
            Text(
              'Nothing yet',
              style: TextStyle(
                fontSize: height * .040,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: height * .030,
                ),
              ),
            ),
            BlocBuilder<GetDataCubit, GetDataState>(builder: (context, state) {
              final Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('user').snapshots();
              return StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  final locPostion = context.read<LocationCubit>().state.location;
                
              });
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
