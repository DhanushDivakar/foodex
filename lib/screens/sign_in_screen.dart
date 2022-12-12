import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodex/bloc/auth_cubit.dart';
import 'package:foodex/bloc/auth_state.dart';
import 'package:foodex/screens/verify_phone_number.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController _verifiyNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signin'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _verifiyNumber,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Phone Number",
                      counterText: "",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if(state is AuthCodeSentState){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return VerifyPhoneNumberScreen();
                        }));

                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            String phoneNumber = '+91${_verifiyNumber.text}';
                            BlocProvider.of<AuthCubit>(context)
                                .sendOTP(phoneNumber);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: ((context) {
                            //       return  VerifyPhoneNumberScreen();
                            //     }),
                            //   ),
                            // );
                          },
                          child: const Text('SignIn'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
