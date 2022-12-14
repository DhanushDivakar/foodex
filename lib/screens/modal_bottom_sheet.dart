import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../bloc/camera_bloc/camera_bloc_bloc.dart';

class ShowModalSheet extends StatelessWidget {
  const ShowModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.indigo[50],
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        BlocConsumer<CameraCubit, String?>(
                          listener: (context, state) {
                            final imageCubit =
                                BlocProvider.of<CameraCubit>(context);
                            if (state == null) {
                              const SnackBar(
                                content: Text('Error acessing camera'),
                              );
                              imageCubit.resetImage();
                            }
                          },
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (state != null && state.isNotEmpty)
                                  SizedBox(
                                    height: height * .10,
                                    width: width * .10,
                                    child: Image.file(
                                      File(state),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<CameraCubit>(context)
                                        .getImage(ImageSource.camera);
                                  },
                                  child: Text(
                                    'Take a picture',
                                    style: TextStyle(
                                      fontSize: height * .025,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   'or',
                                //   style: TextStyle(
                                //     fontSize: height * .020,
                                //   ),
                                // ),
                                // TextButton(
                                //   onPressed: () {
                                //     BlocProvider.of<CameraCubit>(context)
                                //         .getImage(ImageSource.gallery);
                                //   },
                                //   child: Text(
                                //     'Choose a picture',
                                //     style: TextStyle(
                                //       fontSize: height * .025,
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Enter the title';
                            } else {
                              return null;
                            }
                          },
                          controller: titleController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(hintText: 'Title'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return 'Enter the description';
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: descriptionController,
                          decoration:
                              const InputDecoration(hintText: 'Description'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<LocationCubit, LocationState>(
                            builder: (context, state) {
                          if (state.permission ==
                              LocationPermission.whileInUse) {
                            return const SizedBox.shrink();
                          }
                          return TextButton(
                            onPressed: () {},
                            child: const Text('Please allow loction'),
                          );
                        }),
                        BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, state) {
                            // if (state.permission ==
                            //     LocationPermission.whileInUse) {
                            //  // print(state.location.latitude);
                            //   print(state.location.longitude);
                            // }

                            return ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (state.isLoading) {
                                  const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (formKey.currentState?.validate() == true &&
                                    context.read<CameraCubit>().state != null &&
                                    context
                                            .read<LocationCubit>()
                                            .state
                                            .permission ==
                                        LocationPermission.whileInUse) {
                                  final image =
                                      context.read<CameraCubit>().state;
                                  String fileName = basename(image!);

                                  //print(fileName);
                                  FirebaseStorage storage =
                                      FirebaseStorage.instance;
                                  Reference ref =
                                      storage.ref().child('uploads/$fileName');

                                  await ref.putFile(File(image));
                                  String imageUrl = await ref.getDownloadURL();
                                  print(imageUrl);

                                  // await uploadTask.whenComplete(() async {
                                  //   final String imageUrl =
                                  //       await ref.getDownloadURL();
                                  //   // print(url);
                                  // });
                                  // ignore: use_build_context_synchronously
                                  final location = context
                                      .read<LocationCubit>()
                                      .state
                                      .location;
                                  final uid =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(uid)
                                      .set({
                                    'uid': uid,
                                    'image': imageUrl,
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'time': DateTime.now(),
                                    'locationCoords': GeoPoint(
                                      location.latitude,
                                      location.longitude,
                                    ),

                                    // 'latitude':location.latitude,
                                    // 'logitude': location.longitude,
                                  });
                                  print(url);
                                  // ignore: use_build_context_synchronously

                                  print(location.latitude);
                                  print(location.longitude);
                                  print(titleController.text);
                                  print(descriptionController.text);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);

                                  //   print()
                                  //print(formKey.currentState);
                                } else {
                                  if (formKey.currentState?.validate() ==
                                      false) {
                                        showDialog(context: context, builder: (context){
                                          return const Center(child: Text('fill the form'));
                                        });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Enter title and description')));
                                  } else if (context
                                          .read<CameraCubit>()
                                          .state ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('please pick image')));
                                    print('please pick image');
                                  } else if (context
                                          .read<LocationCubit>()
                                          .state
                                          .permission !=
                                      LocationPermission.whileInUse) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.error!)));

                                    print('location not turned on');
                                  }
                                  //Navigator.pop(context);
                                }

                                // FocusScope.of(context).unfocus();
                                // final isValid =
                                //     formKey.currentState!.validate();
                                // if (isValid &&
                                //     context.read<CameraCubit>().state != null &&
                                //     state.toString().isNotEmpty) {
                                //   try {
                                //     // print('accessing');
                                //     if (state.toString().isNotEmpty) {
                                //       BlocProvider.of<LocationCubit>(context)
                                //           .getCurrentPosition();
                                //       //  final Location = context.read<LocationCubit>().getCurrentPosition();
                                //       //  print(Location);

                                //       final image =
                                // BlocProvider.of<CameraCubit>(context)
                                //     .state;
                                //       print(image);
                                //       print("title ${titleController.text}");
                                //       print(
                                //           "desc ${descriptionController.text}");

                                //       //print(image! + 'cool');

                                //       // print('hi');
                                //       if (state is LocationDenied) {
                                //         // print('denied');
                                //       }
                                //     } else {
                                //       //print('error');
                                //     }
                                //   } catch (error) {
                                //     print('error');
                                //     //  showDialog(
                                //     //     context: context,
                                //     //     builder: (ctx) {
                                //     //       return AlertDialog(
                                //     //         title: const Text('Error'),
                                //     //         content:
                                //     //             const Text('Something went wrong'),
                                //     //         actions: <Widget>[
                                //     //           TextButton(
                                //     //             onPressed: () {
                                //     //               Navigator.pop(context);
                                //     //             },
                                //     //             child: const Text('Ok'),
                                //     //           ),
                                //     //         ],
                                //     //       );
                                //     //     });
                                //   }
                                // } else {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content: Text('Something went wrong'),
                                //     ),
                                //   );
                                // }
                              },
                              child: const Text('Submit'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
