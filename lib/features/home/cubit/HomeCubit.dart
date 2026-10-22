
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/category_service.dart';
import 'HomeState.dart';



class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(HomeInitial());


  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final categories = await homeService.getCategories();
      final products = await homeService.getProducts();

      emit(
        HomeSuccess(
          categories: categories,
          products: products,
        ),
      );
    } on DioException catch (e) {
      emit(
        HomeError(
          e.response?.data is Map
              ? e.response?.data['message']?.toString() ??
              'Something went wrong'
              : e.message ?? 'Something went wrong',
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to load home data: $e'));
    }
  }
}