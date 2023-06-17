import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../presentation/screens/home/home_screen.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(const BottomNavigationState(routeName: HomeScreen.routeName));

  void switchToPage(String routeName) {
    emit(BottomNavigationState(routeName: routeName));
  }
}
