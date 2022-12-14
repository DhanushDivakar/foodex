import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/auth_cubit.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:foodex/screens/modal_bottom_sheet.dart';

import 'package:foodex/screens/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    context.read<LocationCubit>().getCurrentPosition();

    return Scaffold(
      appBar: AppBar(
        title:  BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
           if(state is LocationDenied){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Turn on Location')));
           }
          },
          child: Text('Foodex'),
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
