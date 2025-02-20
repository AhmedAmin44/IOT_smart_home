import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_breif.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_header.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/admin_specific_widget.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/last_password_widget.dart';

class HomeView extends StatelessWidget {
  final String role;
  final String familyId;

  const HomeView({super.key, required this.role, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 35,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                HomeHeader(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: HomeBreif(role: role),
          ),
          if (role == 'father' || role == 'mother')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.family_restroom),
                  label: const Text('إدارة العائلة'),
                  onPressed: () => context.go('/family-setup', extra: {'role': role, 'familyId': familyId}),
                ),
              ),
            ),
          if (role == 'father')
            SliverToBoxAdapter(
              child: AdminSpecificWidget(role: 'father', familyId: familyId),
            ),
          if (role == 'user')
            BlocProvider(
              create: (context) => HomeCubit(),
              child: SliverToBoxAdapter(
                child: LastPasswordWidget(),
              ),
            ),
        ],
      ),
    );
  }
}