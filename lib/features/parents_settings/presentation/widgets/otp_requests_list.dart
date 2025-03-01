import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../parent_cubit/parent_cubit.dart';

class OtpRequestsList extends StatelessWidget {
  final String familyId;

  const OtpRequestsList({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentCubit = context.read<ParentCubit>();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: parentCubit.getOtpRequests(familyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending requests.'
          ,style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
          ));
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final requestData = requests[index].data();
            final requestId = requests[index].id;
            final deviceName = requestData['deviceName'] ?? '';
            // final otp = requestData['otp'] ?? '';
            final timestamp = requestData['timestamp'] != null
                ? (requestData['timestamp'] as Timestamp).toDate()
                : null;
            final formattedTime = timestamp != null
                ? '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'
                : 'N/A';

            return Card(
  color: AppColors.secColor, // Updated background color
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      title: Text(
        'Device: $deviceName',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green, // Updated title color
        ),
      ),
      // subtitle: Text(
      //   // 'OTP: $otp\nTime: $formattedTime',
      //   style: const TextStyle(color: Colors.white), // Updated subtitle color
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2), // Soft green background
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => parentCubit.approveRequest(requestId),
            ),
          ),
          const SizedBox(width: 8), // Space between buttons
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2), // Soft red background
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => parentCubit.rejectRequest(requestId),
            ),
          ),
        ],
      ),
    ),
  ),
);

          },
        );
      },
    );
  }
}
