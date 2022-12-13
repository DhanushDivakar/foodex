import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/auth_cubit.dart';
import 'package:foodex/bloc/camera_bloc/camera_bloc_bloc.dart';
import 'package:foodex/screens/sign_in_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foodex'),
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
      body: SingleChildScrollView(
        child: BlocConsumer<CameraCubit, String?>(
          listener: (context, state) {
            final imageCubit = BlocProvider.of<CameraCubit>(context);
            if (state == null) {
              const SnackBar(
                content: Text('Error'),
              );
              imageCubit.resetImage();
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  if (state != null && state.isNotEmpty) Image.file(File(state)),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CameraCubit>(context)
                          .getImage(ImageSource.camera);
                    },
                    child: const Text('Camera'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CameraCubit>(context)
                          .getImage(ImageSource.gallery);
                    },
                    child: const Text('Gallery'),
                  ),
                  ElevatedButton(onPressed: (){}, child:const  Text('get location'))
                  // Image.file(File(state!)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
