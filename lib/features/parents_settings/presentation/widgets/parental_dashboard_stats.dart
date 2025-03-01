import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../parent_cubit/parent_cubit.dart';

class ParentalStats extends StatelessWidget {
  final String familyId;

  const ParentalStats({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentCubit = context.read<ParentCubit>();

    return Row(spacing: 25,
      children: [
        Expanded(
          child: _buildStatCard("Total Devices", parentCubit.getTotalDevicesCount(familyId)),
        ),
        Expanded(
          child: _buildStatCard("Active Requests", parentCubit.getActiveRequestsCount(familyId)),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, Stream<int> stream,) {
  return StreamBuilder<int>(
    stream: stream,
    builder: (context, snapshot) {
      int count = snapshot.data ?? 0;
      return Container(
        width: 160,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, color: Colors.white ,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}