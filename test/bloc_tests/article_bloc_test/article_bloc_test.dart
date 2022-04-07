import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_newsapp/bloc/article_bloc/article_bloc.dart';
import 'package:flutter_newsapp/bloc/article_bloc/article_event.dart';
import 'package:flutter_newsapp/bloc/article_bloc/article_state.dart';
import 'package:flutter_newsapp/data/models/api_model.dart';
import 'package:flutter_newsapp/data/models/exceptions.dart';
import 'package:flutter_newsapp/data/repositories/article_repo.dart';
import 'package:flutter_newsapp/data/repositories/local_article_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'article_bloc_test.mocks.dart';
// import 'package:user_repository/user_repository.dart';

// import 'package:flutter_login/authentication/authentication.dart';

// class MockLangRepository extends Mock implements LangRepository {}

@GenerateMocks([NetworkArticlesRepository, LocalArticlesRepository])
void main() {
  late ArticlesBloc articlesBloc;
  late NetworkArticlesRepository mockNetworkRepository;
  late LocalArticlesRepository mockLocalRepository;

  setUp(() {
    mockNetworkRepository = MockNetworkArticlesRepository();
    mockLocalRepository = MockLocalArticlesRepository();
    articlesBloc = ArticlesBloc(
        networkRepository: mockNetworkRepository,
        localRepository: mockLocalRepository);
  });

  tearDown(() {
    articlesBloc.close();
  });

  var article1 = Article(title: 'fake article 1');
  var article2 = Article(title: 'fake article 2');
  var article3 = Article(title: 'fake article 3');
  var article4 = Article(title: 'fake article 4');
  var article5 = Article(title: 'fake article 5');
  var article6 = Article(title: 'fake article 6');
  var article7 = Article(title: 'fake article 7');
  var article8 = Article(title: 'fake article 8');
  var article9 = Article(title: 'fake article 9');
  var article10 = Article(title: 'fake article 10');
  var article11 = Article(title: 'fake article 11');
  var list1 = [
    article1,
    article2,
    article3,
    article4,
    article5,
    article6,
    article7,
    article8,
    article9
  ];

  group('RegisterRepoEvent', () {
    blocTest(
      'initial is ArticlesInitialState',
      build: () {
        return articlesBloc;
      },
      act: (ArticlesBloc bloc) => bloc.add(RegisterRepoEvent()),
      expect: () => [
        ArticlesInitialState(),
      ],
    );
  });
  group('ClearLocalArticlesEvent', () {
    blocTest('on clear check values ',
        build: () {
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(ClearLocalArticlesEvent()),
        expect: () => [
              ClearedLocalArticalsState(),
            ],
        verify: (ArticlesBloc bloc) {
          expect(bloc.articlesList.isEmpty, true);
          expect(bloc.isFetching, false);
          expect(bloc.page, 1);
          expect(bloc.totalResults, null);
        });
    blocTest('fetch network then clear event emit  ',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(true);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article1,
                    article2,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) async {
          bloc.add(FetchArticlesEvent());
          await Future.delayed(Duration(milliseconds: 1));
          bloc.add(ClearLocalArticlesEvent());
        },
        expect: () => [
              ArticlesLoadingState(),
              ArticlesLoadedState(
                  articles: [article1, article2],
                  message: 'New news were added'),
              ClearedLocalArticalsState(),
            ],
        verify: (ArticlesBloc bloc) {
          expect(bloc.articlesList.isEmpty, true);
          expect(bloc.isFetching, false);
          expect(bloc.page, 1);
          expect(bloc.totalResults, null);
        });
  });
  group('FetchArticlesEvent', () {
    group('-one network request', () {
      blocTest(
        'first fetch works',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(true);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article1,
                    article2,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
            article2,
          ], message: 'New news were added'),
        ],
      );

      blocTest(
        'get articles from local works when offline',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
                article2,
              ]);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenThrow((_) async =>
                  CustomNetworkException(massage: 'no internet connection'));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
            article2,
          ], message: 'local stored news'),
          ArticlesLoadedState(articles: [
            article1,
            article2,
          ], message: 'No Network connection'),
        ],
      );
      blocTest(
        'get local works when online and add new network articles',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
              ]);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article2,
                    article3,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
          ], message: 'local stored news'),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
          ], message: 'New news were added'),
        ],
      );
      blocTest(
        'get local and update any local duplicates from network articles',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
                article2,
                article3,
                article4,
              ]);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
                article2,
                article3,
                article4,
              ]);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article2,
                    article3,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
          ], message: 'local stored news'),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
          ], message: 'Some news were updated'),
        ],
      );
      blocTest(
        'get local and update duplicate and add new ones',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
                article2,
                article3,
                article4,
              ]);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article2,
                    article3,
                    article7,
                    article9,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
          ], message: 'local stored news'),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
            article7,
            article9,
          ], message: 'New news were added'),
        ],
      );
      blocTest(
        'get local and update duplicate and add new ones',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles()).thenAnswer((_) async => [
                article1,
                article2,
                article3,
                article4,
              ]);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article2,
                    article3,
                    article7,
                    article9,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) => bloc.add(FetchArticlesEvent()),
        expect: () => [
          ArticlesLoadingState(),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
          ], message: 'local stored news'),
          ArticlesLoadedState(articles: [
            article1,
            article2,
            article3,
            article4,
            article7,
            article9,
          ], message: 'New news were added'),
        ],
      );
    });

    group('-two network requests', () {
      blocTest(
        'first and second fetch works',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(true);
          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article1,
                    article2,
                  ]));
          when(mockNetworkRepository.getArticles(2, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article3,
                    article4,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) async {
          bloc.add(FetchArticlesEvent());
          await Future.delayed(Duration(milliseconds: 1));
          bloc.add(FetchArticlesEvent());
        },
        expect: () {
          return [
            ArticlesLoadingState(),
            ArticlesLoadedState(articles: [
              article1,
              article2,
            ], message: 'New news were added'),
            ArticlesLoadedState(
                articles: [article1, article2], message: 'Loading ...'),
            ArticlesLoadedState(articles: [
              article1,
              article2,
              article3,
              article4,
            ], message: 'New news were added')
          ];
        },
      );
      blocTest(
        'get local and first and second fetch works',
        build: () {
          when(mockLocalRepository.isEmpty).thenReturn(false);
          when(mockLocalRepository.getArticles())
              .thenAnswer((_) async => [...list1, article10, article11]);

          when(mockNetworkRepository.getArticles(1, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article1,
                    article2,
                  ]));
          when(mockNetworkRepository.getArticles(2, articlesBloc.itemsPerPage))
              .thenAnswer((_) async => ApiResultModel(articles: [
                    article3,
                    article4,
                  ]));
          return articlesBloc;
        },
        act: (ArticlesBloc bloc) async {
          bloc.add(FetchArticlesEvent());
          await Future.delayed(Duration(milliseconds: 1));
          bloc.add(FetchArticlesEvent());
        },
        expect: () {
          return [
            ArticlesLoadingState(),
            ArticlesLoadedState(
                articles: [...list1, article10, article11],
                message: 'local stored news'),
            ArticlesLoadedState(
                articles: [...list1, article10, article11],
                message: 'Some news were updated'),
            ArticlesLoadedState(
                articles: [...list1, article10, article11],
                message: 'Loading ...'),
            ArticlesLoadedState(
                articles: [...list1, article10, article11],
                message: 'Some news were updated'),
          ];
        },
      );
    });
  });
}
