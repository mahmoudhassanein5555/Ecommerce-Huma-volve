import 'package:ecommerce_app_huma_volve/features/profile/domain/entities/user_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserEntity user;
  ProfileSuccess(this.user);
}

class ProfileError extends ProfileState {
  final String msg;
  ProfileError(this.msg);
}
