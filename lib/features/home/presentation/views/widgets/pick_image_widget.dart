import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:IOT_SmartHome/core/function/custom_troast.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is UploadProfilePicError){
          ShowToast(""" No image selected,
          Upload a new photo. """);
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 50,
          height: 50,
          child: context.read<HomeCubit>().profilePic == null
              ? CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const AssetImage("assets/images/avatar.png"),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          ImagePicker();
                          context.read<HomeCubit>().pickAndUploadProfilePic();
                        
                        },
                        child: const Icon(
                          Icons.camera_alt_sharp,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
              : CircleAvatar(
            backgroundImage: FileImage(
                File(context.read<HomeCubit>().profilePic!.path)),
          ),
        );
      },
    );
  }
}
