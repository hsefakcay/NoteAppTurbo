part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({required this.isLoading, this.user, this.errorMessage});

  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const AuthState.unauthenticated() : this(isLoading: false, user: null, errorMessage: null);
  const AuthState.authenticated(User? user)
    : this(isLoading: false, user: user, errorMessage: null);

  bool get isAuthenticated => user != null;

  AuthState copyWith({bool? isLoading, User? user, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, user?.uid, errorMessage];
}
