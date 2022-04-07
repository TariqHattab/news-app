import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_newsapp/res/common_functions.dart';

import '../../data/repositories/lang_repo.dart';
import 'lang_event.dart';
import 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  LangRepository repository;
  LangBloc({required this.repository}) : super(LangInitialState()) {
    on<RegisterLangEvent>((event, emit) async {
      emit(LangLoadingState());
      await _langInit();
      emit(LangInitialState(locale: _locale));
    });

    on<ToggleLangEvent>((event, emit) async {
      emit(LangLoadingState());
      _toggleLocale();
      emit(LangLoadedState(locale: _locale));
    });
  }

  LangState get initialState => LangInitialState();

  Locale _locale = LangInitialState().locale;
  Locale get locale => _locale;

  Future<void> _langInit() async {
    try {
      await repository.init();
      if (repository.isEmpty) {
        //no value stored yet
        repository.addLang(_locale.toLanguageTag());
      } else {
        //get stored value
        _locale = await repository.getLang();
      }
    } catch (e) {
      printData('failed to add or init or get lang repo , e = $e');
    }
  }

  void _toggleLocale() {
    if (_locale == Locale('en')) {
      _locale = Locale('ar');
    } else {
      _locale = Locale('en');
    }
    try {
      if (repository.isEmpty) {
        repository.addLang(_locale.toLanguageTag());
      } else {
        repository.updateLang(_locale.toLanguageTag());
      }
    } catch (e) {
      printData('failed to add or update e = $e ');
    }
  }
}
