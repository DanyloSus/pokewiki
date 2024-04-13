import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<String> {
  UserCubit() : super("");

  Future<void> loadValues() async {
    SharedPreferences.getInstance().then((prefs) {
      emit(prefs.getString('username') ?? "");
    });
  }

  void setUser(String newUser) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('username', newUser);
    }).then((v) => emit(newUser));
  }
}
