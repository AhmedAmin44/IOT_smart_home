import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/home/presentation/home_cubit/home_cubit.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_breif.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/home_header.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/admin_specific_widget.dart';
import 'package:IOT_SmartHome/features/home/presentation/views/widgets/last_password_widget.dart';

class HomeView extends StatelessWidget {
  final String role;
  const HomeView({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 35,
            ),
          ),
          SliverToBoxAdapter(
            child: HomeHeader(),
          ),
          SliverToBoxAdapter(
            child: HomeBreif(
              role: role,
            ),
          ),
          if (role == 'admin')
            SliverToBoxAdapter(
              child: AdminSpecificWidget(),
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
