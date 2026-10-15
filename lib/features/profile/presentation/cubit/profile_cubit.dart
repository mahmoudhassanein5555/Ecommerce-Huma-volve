import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/get_profile.dart';
import 'package:ecommerce_app_huma_volve/features/profile/domain/use_cases/logout.dart';
import 'package:ecommerce_app_huma_volve/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final Logout _logout;

  ProfileCubit(this._getProfile, this._logout) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await _getProfile();
    result.fold(
      (failure) => emit(ProfileError(failure.msg)),
      (user) => emit(ProfileSuccess(user)),
    );
  }

  Future<void> logout() async {
    await _logout();
    emit(ProfileInitial());
  }
}
