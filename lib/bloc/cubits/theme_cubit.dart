import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(true);

  Future<void> loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getBool('theme') == null ? true : prefs.getBool('theme')!);
  }

  void toogle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('theme', !state).then((v) => emit(!state));
  }
}
