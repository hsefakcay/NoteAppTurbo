import 'package:bloc/bloc.dart';
import 'settings_state.dart';

/// Ayarlar ekranı için Cubit
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  /// Ayarları yükle
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    // Burada gerekirse ayarları yükleyebiliriz
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isLoading: false));
  }

  /// Hata durumunu temizle
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
