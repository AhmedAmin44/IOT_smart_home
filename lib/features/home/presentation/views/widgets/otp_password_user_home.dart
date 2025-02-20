// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:IOT_SmartHome/core/function/custom_troast.dart';
// import 'package:IOT_SmartHome/core/function/navigation.dart';
// import 'package:IOT_SmartHome/core/utils/app_colors.dart';
// import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_cubit.dart';
// import 'package:IOT_SmartHome/features/auth/presentation/auth_cubit/auth_state.dart';
// import 'package:IOT_SmartHome/features/otp_screen/presentation/cubit/otp_cubit.dart';

// class OtpScreenUserHome extends StatefulWidget {
//   const OtpScreenUserHome({super.key});

//   @override
//   State<OtpScreenUserHome> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreenUserHome> {
//   TextEditingController otp1Controller = TextEditingController();
//   TextEditingController otp2Controller = TextEditingController();
//   TextEditingController otp3Controller = TextEditingController();
//   TextEditingController otp4Controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.bgColor,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => customNavigateReplacement(context, "/homeNavBar"),
//           icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryColor),
//         ),
//       ),
//       body: BlocListener<OtpCubit, OtpState>(
//         listener: (context, state) {
//           if (state is OTPVerified) {
//             customNavigate(context, "/homeNavBar");
//           } else if (state is OTPFailed) {
//             ShowToast(state.error);
//           }
//         },
//         child: CustomScrollView(
//           slivers: [
//             SliverFillRemaining(
//               hasScrollBody: false,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.dialpad_rounded, size: 50, color: AppColors.prColor),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Enter Your OTP",
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         OtpField(otpController: otp1Controller),
//                         OtpField(otpController: otp2Controller),
//                         OtpField(otpController: otp3Controller),
//                         OtpField(otpController: otp4Controller),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         String otp = otp1Controller.text +
//                             otp2Controller.text +
//                             otp3Controller.text +
//                             otp4Controller.text;

//                         context.read<OtpCubit>().verifyOTP(otp);
//                       },
//                       child: Text(
//                         "Verify OTP",
//                         style: TextStyle(fontSize: 18, color: AppColors.prColor),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Didn't receive a code?",
//                       style: TextStyle(fontSize: 16, color: Colors.red),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.read<AuthCubit>().sendOTP();
//                       },
//                       child: const Text(
//                         "Resend OTP",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OtpField extends StatelessWidget {
//   const OtpField({
//     super.key,
//     required this.otpController,
//   });

//   final TextEditingController otpController;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 50,
//       height: 50,
//       child: TextFormField(
//         controller: otpController,
//         keyboardType: TextInputType.number,
//         style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//               color: AppColors.prColor,
//             ),
//         textAlign: TextAlign.center,
//         inputFormatters: [
//           LengthLimitingTextInputFormatter(1),
//           FilteringTextInputFormatter.digitsOnly,
//         ],
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.isEmpty) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         decoration: const InputDecoration(
//           hintText: '-',
//           hintStyle: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
