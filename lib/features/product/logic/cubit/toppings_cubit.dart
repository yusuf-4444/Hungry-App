import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_state.dart';

class ToppingsCubit extends Cubit<ToppingsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  ToppingsCubit(this.toppingsSideOptionsRepo)
    : super(const ToppingsState.initial());

  // الداتا المحفوظة
  ToppingsModel? _cachedToppings;

  // فلاج للتأكد إننا جبنا الداتا قبل كده
  bool _hasLoadedData = false;

  Future<void> getToppings({bool forceRefresh = false}) async {
    // لو عندنا الداتا محفوظة ومش عايزين نعمل refresh، نرجع الداتا المحفوظة
    if (_hasLoadedData && _cachedToppings != null && !forceRefresh) {
      emit(ToppingsState.success(_cachedToppings!));
      return;
    }

    // لو مفيش داتا أو عايزين نعمل refresh، نجيب من الـ API
    emit(const ToppingsState.loading());

    try {
      final response = await toppingsSideOptionsRepo.getToppings();

      response.when(
        success: (success) {
          // نحفظ الداتا
          _cachedToppings = success;
          _hasLoadedData = true;

          // نحدث الـ global variable كمان (اختياري)
          toppingsModel = success;

          emit(ToppingsState.success(success));
        },
        failure: (error) => emit(ToppingsState.failure(error)),
      );
    } catch (e) {
      emit(ToppingsState.failure(e.toString()));
    }
  }

  // دالة للـ refresh لو احتجناها
  Future<void> refreshToppings() async {
    await getToppings(forceRefresh: true);
  }

  // دالة لمسح الـ cache لو احتجناها
  void clearCache() {
    _cachedToppings = null;
    _hasLoadedData = false;
    emit(const ToppingsState.initial());
  }
}
