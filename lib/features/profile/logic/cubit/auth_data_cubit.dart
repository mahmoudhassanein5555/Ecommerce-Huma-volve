import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_data_state.dart';

class AuthDataCubit extends Cubit<AuthDataState> {
  AuthDataCubit() : super(AuthDataInitial());
}
