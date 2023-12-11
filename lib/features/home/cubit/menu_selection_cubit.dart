import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class MenuSelectionCubit extends Cubit<int> {
  MenuSelectionCubit() : super(0);

  void selectAbout() => emit(1);

  void selectServices() => emit(2);

  void selectProjects() => emit(3);

  void selectContactUs() => emit(4);

  void selectNone() => emit(0);

  bool get isAboutSelected => state == 1;

  bool get isServicesSelected => state == 2;

  bool get isProjectsSelected => state == 3;

  bool get isContactUsSelected => state == 4;
}
