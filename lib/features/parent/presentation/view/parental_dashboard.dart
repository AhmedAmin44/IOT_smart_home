import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:IOT_SmartHome/features/parent/presentation/parent_cubit/parent_cubit.dart';
import 'package:IOT_SmartHome/features/parent/presentation/widgets/otp_requests_list.dart';
import 'package:IOT_SmartHome/features/parent/presentation/widgets/parental_dashboard_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';

class ParentalDashboard extends StatelessWidget {
  final String familyId;

  const ParentalDashboard({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentCubit()..initialize(familyId: familyId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text("Devices DashBoard Status",
              style: CustomTextStyles.pacifico400style64
                  .copyWith(fontSize: 15, color: AppColors.primaryColor)),
          leading: Icon(
            FontAwesomeIcons.lightbulb,
            color: Colors.green,
            size: 28,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ParentalStats(familyId: familyId),
              const SizedBox(height: 20),
              Expanded(child: OtpRequestsList(familyId: familyId)),
              
            ],
          ),
        ),
      ),
    );
  }
}
