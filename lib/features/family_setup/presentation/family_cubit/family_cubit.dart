import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'family_state.dart';

class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit() : super(FamilyInitial());
}
