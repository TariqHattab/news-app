import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LangState extends Equatable {}

class LangInitialState extends LangState {
  final Locale locale;

  LangInitialState({this.locale = const Locale('en')});

  @override
  List<Object> get props => [locale];
}

class LangLoadingState extends LangState {
  @override
  List<Object> get props => [];
}

class LangLoadedState extends LangState {
  Locale locale;
  LangLoadedState({required this.locale});

  @override
  List<Object> get props => [locale];
}

// class LangErrorState extends LangState {
//   final String message;
//   LangErrorState({required this.message});
//   @override
//   List<Object> get props => [message];
// }
