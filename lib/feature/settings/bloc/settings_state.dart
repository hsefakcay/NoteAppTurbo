import 'package:equatable/equatable.dart';

/// Ayarlar ekranı state sınıfı
class SettingsState extends Equatable {
  const SettingsState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  SettingsState copyWith({bool? isLoading, String? errorMessage}) {
    return SettingsState(isLoading: isLoading ?? this.isLoading, errorMessage: errorMessage);
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
