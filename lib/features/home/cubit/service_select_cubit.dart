import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class ServiceSelectCubit extends Cubit<int> {
  ServiceSelectCubit() : super(0);

  void selectBranding() => emit(0);

  void selectPdd() => emit(1);
}
