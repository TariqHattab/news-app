import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_newsapp/bloc/lang_bloc/lang_bloc.dart';
import 'package:flutter_newsapp/bloc/lang_bloc/lang_event.dart';
import 'package:flutter_newsapp/bloc/lang_bloc/lang_state.dart';
import 'package:flutter_newsapp/data/repositories/lang_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';

import 'lang_bloc_test.mocks.dart';

@GenerateMocks([LangRepository])
void main() {
  late LangBloc langBloc;
  late MockLangRepository mockLangRepository;

  setUp(() {
    mockLangRepository = MockLangRepository();
    langBloc = LangBloc(repository: mockLangRepository);
  });

  tearDown(() {
    langBloc.close();
  });

  group('GroupRegisterLangEvent', () {
    blocTest(
      'initial is english',
      build: () {
        return LangBloc(repository: mockLangRepository);
      },
      act: (LangBloc bloc) => bloc.add(RegisterLangEvent()),
      expect: () => [
        LangLoadingState(),
        LangInitialState(locale: Locale('en')),
      ],
    );
    blocTest(
      'check locale returned is same as stored in device when locale = en',
      build: () {
        // when(mLR.init()).thenAnswer((_) async => Locale('en'));
        when(mockLangRepository.isEmpty).thenReturn(false);
        when(mockLangRepository.getLang())
            .thenAnswer((_) async => Locale('en'));

        return LangBloc(repository: mockLangRepository);
      },
      act: (LangBloc bloc) => bloc.add(RegisterLangEvent()),
      expect: () => [
        LangLoadingState(),
        LangInitialState(locale: Locale('en')),
      ],
    );
    blocTest(
      'check locale returned is same as stored in device when locale = ar',
      build: () {
        when(mockLangRepository.isEmpty).thenReturn(false);
        when(mockLangRepository.getLang())
            .thenAnswer((_) async => Locale('ar'));

        return LangBloc(repository: mockLangRepository);
      },
      act: (LangBloc bloc) => bloc.add(RegisterLangEvent()),
      expect: () => [
        LangLoadingState(),
        LangInitialState(locale: Locale('ar')),
      ],
    );
  });

  group('Group ToggleLangEvent', () {
    blocTest(
      'changing the initial local when locale = en',
      build: () {
        return langBloc;
      },
      act: (LangBloc bloc) => bloc.add(ToggleLangEvent()),
      expect: () => [
        LangLoadingState(),
        LangLoadedState(locale: Locale('ar')),
      ],
    );
    blocTest(
      'changing the initial local when locale = ar',
      build: () {
        when(mockLangRepository.isEmpty).thenReturn(false);
        when(mockLangRepository.getLang())
            .thenAnswer((_) async => Locale('ar'));
        return langBloc;
      },
      act: (LangBloc bloc) async {
        bloc.add(RegisterLangEvent());
        await Future.delayed(Duration(milliseconds: 1));
        bloc.add(ToggleLangEvent());
      },
      expect: () => <LangState>[
        LangLoadingState(),
        LangInitialState(locale: Locale('ar')),
        LangLoadingState(),
        LangLoadedState(locale: Locale('en')),
      ],
    );

    blocTest(
      'changing the initial local when locale = en',
      build: () {
        return langBloc;
      },
      act: (LangBloc bloc) => bloc.add(ToggleLangEvent()),
      expect: () => [
        LangLoadingState(),
        LangLoadedState(locale: Locale('ar')),
      ],
    );
  });
}
