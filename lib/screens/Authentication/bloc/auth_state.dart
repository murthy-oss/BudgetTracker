part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class AuthActionState extends AuthState{}
class NavigateAuthToHomeState extends AuthActionState{}
