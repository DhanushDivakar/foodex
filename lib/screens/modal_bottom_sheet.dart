import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/cubit/location_cubit.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/camera_bloc/camera_bloc_bloc.dart';

class ShowModalSheet extends StatelessWidget {
  const ShowModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

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
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BlocConsumer<CameraCubit, String?>(
                      listener: (context, state) {
                        final imageCubit =
                            BlocProvider.of<CameraCubit>(context);
                        if (state == null) {
                          const SnackBar(
                            content: Text('Error'),
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
                                'Click a picture',
                                style: TextStyle(
                                  fontSize: height * .025,
                                ),
                              ),
                            ),
                            Text(
                              'or',
                              style: TextStyle(
                                fontSize: height * .020,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                BlocProvider.of<CameraCubit>(context)
                                    .getImage(ImageSource.gallery);
                              },
                              child: Text(
                                'Choose a picture',
                                style: TextStyle(
                                  fontSize: height * .025,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<LocationCubit, LocationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            try {
                              print('accessing');
                              if (state.toString().isNotEmpty) {
                                BlocProvider.of<LocationCubit>(context)
                                    .getCurrentPosition();
                                print('hi');
                                if (state is LocationDenied) {
                                  print('denied');
                                }
                              } else {
                                print('error');
                              }
                            } catch (error) {
                              print('error');
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content:
                                          const Text('Something went wrong'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: const Text('Submit'),
                        );
                      },
                    ),
                  ],
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
