import 'package:IOT_SmartHome/core/utils/app_colors.dart';
import 'package:IOT_SmartHome/core/utils/app_text_style.dart';
import 'package:IOT_SmartHome/core/widgets/customButton.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/family_cubit/family_cubit.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/invite_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/family_id_card.dart';
import 'package:IOT_SmartHome/features/family_setup/presentation/widgets/family_members_list.dart';

class FatherView extends StatelessWidget {
  final String familyId;
  final String currentUserRole = 'father'; // Assuming the current user is the father

  const FatherView({Key? key, required this.familyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FamilyCubit(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FamilyIdCard(familyId: familyId),
            const SizedBox(height: 20),
            Text(
              "Family Members",
              style: CustomTextStyles.pacifico400style64
                  .copyWith(fontSize: 30, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 20),
            BlocBuilder<FamilyCubit, FamilyState>(
              builder: (context, state) {
                final cubit = context.read<FamilyCubit>();
                return FamilyMembersList(
                  familyId: familyId,
                  onRemoveMember: (ctx, userId) =>
                      cubit.removeMember(ctx, userId, currentUserRole),
                  onUpdateMember: (ctx, userId, firstName, lastName, role) =>
                      cubit.updateMember(
                          ctx, userId, firstName, lastName, role),
                );
              },
            ),
            const SizedBox(height: 20),
            CustomBotton(
              text: "Add Member !",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => FamilyCubit(),
                      child: InviteFamilyMember(familyId: familyId),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
