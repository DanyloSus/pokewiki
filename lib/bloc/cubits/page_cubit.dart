import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  Future<void> loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getInt('page') ?? 0);
  }

  void changePage(int newPage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('page', newPage);

    emit(newPage);
  }
}
