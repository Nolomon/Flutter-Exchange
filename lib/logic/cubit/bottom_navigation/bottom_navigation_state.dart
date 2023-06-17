part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  final String routeName;
  const BottomNavigationState({required this.routeName});

  @override
  List<Object> get props => [GlobalKey()];
}
