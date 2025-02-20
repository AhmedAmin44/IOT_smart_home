import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';
import 'package:IOT_SmartHome/features/otp_screen/presentation/otp_cubit/otp_cubit.dart';

import '../../../../otp_screen/presentation/views/otp_verification.dart';

class LastPasswordWidget extends StatefulWidget {
  const LastPasswordWidget({Key? key}) : super(key: key);

  @override
  State<LastPasswordWidget> createState() => _LastPasswordWidgetState();
}

class _LastPasswordWidgetState extends State<LastPasswordWidget> {
  bool isPasswordVisible = false; 
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeCubit>().fetchLastPassword());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        String password = "************";

        if (homeState is LastPasswordVisible) {
          password = homeState.password;
        } else if (homeState is LastPasswordLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeState is LastPasswordError) {
          return Text(homeState.message,
              style: const TextStyle(color: Colors.red));
        }

        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 73, 89, 97),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Generated Password:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isPasswordVisible ? password : "************",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (!isPasswordVisible) {
                        final verified = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => OtpCubit(),
                              child: const OtpScreen(
                                  successRoute: "verifyForPassword"),
                            ),
                          ),
                        );
                        if (verified == true) {
                          setState(() {
                            isPasswordVisible = true;
                          });
                        }
                      } else {
                        setState(() {
                          isPasswordVisible = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
