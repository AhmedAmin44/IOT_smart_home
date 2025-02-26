import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/family_cubit/family_cubit.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/invite_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InviteFamilyMember extends StatelessWidget {
  final String familyId;

  const InviteFamilyMember({Key? key, required this.familyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.green),
        ),
        title: Text("Invite Family Member",
            style: CustomTextStyles.pacifico400style64
                .copyWith(fontSize: 19, color: AppColors.primaryColor)),
        centerTitle: true,
      ),
      body: BlocBuilder<FamilyCubit, FamilyState>(
        builder: (context, state) {
          final cubit = context.read<FamilyCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Please fill this data ",
                    style: CustomTextStyles.pacifico400style64
                        .copyWith(fontSize: 22, color: AppColors.offWhite,fontFamily: 'poppins')),
                InviteForm(
                  emailController: cubit.emailController,
                  firstNameController: cubit.firstNameController,
                  lastNameController: cubit.lastNameController,
                  passwordController: cubit.passwordController,
                  selectedRole: cubit.selectedRole,
                  onRoleChanged: cubit.changeRole,
                  onSendInvite: () => cubit.sendInvite(familyId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
