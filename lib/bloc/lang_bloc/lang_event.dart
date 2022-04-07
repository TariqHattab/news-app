//only one event for fetching from api
import 'package:equatable/equatable.dart';

abstract class LangEvent extends Equatable {}

class ToggleLangEvent extends LangEvent {
  @override
  List<Object> get props => [];
}

class RegisterLangEvent extends LangEvent {
  @override
  List<Object> get props => [];
}
