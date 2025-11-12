import 'package:equatable/equatable.dart';
import '../../../login/data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModelSp user;
  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {
  final UserModelSp user;
  ProfileUpdated(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
