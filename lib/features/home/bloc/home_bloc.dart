import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeInitial()) {
    on<HomeLoadEvent>(_onLoad);
  }

  final HomeRepository _repository;

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final data = await _repository.loadHomeData();
      emit(HomeLoadedState(
        banners: data.banners,
        categories: data.categories,
        topProducts: data.topProducts,
        flashDeals: data.flashDeals,
        newArrivals: data.newArrivals,
        recommended: data.recommended,
      ));
    } catch (e, _) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
