// Mocks generated by Mockito 5.1.0 from annotations
// in flutter_newsapp/test/bloc_tests/article_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter_newsapp/data/models/api_model.dart' as _i2;
import 'package:flutter_newsapp/data/repositories/article_repo.dart' as _i3;
import 'package:flutter_newsapp/data/repositories/local_article_repo.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeApiResultModel_0 extends _i1.Fake implements _i2.ApiResultModel {}

/// A class which mocks [NetworkArticlesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkArticlesRepository extends _i1.Mock
    implements _i3.NetworkArticlesRepository {
  MockNetworkArticlesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.ApiResultModel> getArticles(int? page, int? itemsPerPage) =>
      (super.noSuchMethod(Invocation.method(#getArticles, [page, itemsPerPage]),
              returnValue:
                  Future<_i2.ApiResultModel>.value(_FakeApiResultModel_0()))
          as _i4.Future<_i2.ApiResultModel>);
}

/// A class which mocks [LocalArticlesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalArticlesRepository extends _i1.Mock
    implements _i5.LocalArticlesRepository {
  MockLocalArticlesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isEmpty =>
      (super.noSuchMethod(Invocation.getter(#isEmpty), returnValue: false)
          as bool);
  @override
  _i4.Future<void> init() => (super.noSuchMethod(Invocation.method(#init, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i2.Article>> getArticles() =>
      (super.noSuchMethod(Invocation.method(#getArticles, []),
              returnValue: Future<List<_i2.Article>>.value(<_i2.Article>[]))
          as _i4.Future<List<_i2.Article>>);
  @override
  _i4.Future<void> updateLocalArticle(_i2.Article? article) =>
      (super.noSuchMethod(Invocation.method(#updateLocalArticle, [article]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> addLocalArticles(List<_i2.Article>? articles) =>
      (super.noSuchMethod(Invocation.method(#addLocalArticles, [articles]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> clearBox() =>
      (super.noSuchMethod(Invocation.method(#clearBox, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}
