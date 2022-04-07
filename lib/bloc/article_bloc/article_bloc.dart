import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_newsapp/data/repositories/local_article_repo.dart';

import '../../data/models/api_model.dart';
import '../../data/repositories/article_repo.dart';
import '../../res/common_functions.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  NetworkArticlesRepository networkRepository;
  LocalArticlesRepository localRepository;

  ArticlesBloc({
    required this.networkRepository,
    required this.localRepository,
  }) : super(ArticlesInitialState()) {
    on<RegisterRepoEvent>((event, emit) async {
      await localRepository.init();
      emit(ArticlesInitialState());
    });

    on<ClearLocalArticlesEvent>((event, emit) async {
      _resetBlocData();
      await localRepository.clearBox();
      emit(ClearedLocalArticalsState());
    });

    on<FetchArticlesEvent>((event, emit) async {
      if (_isFetching) {
        emit(ArticlesLoadingState());
      } else {
        if (_articlesList.isEmpty) {
          emit(ArticlesLoadingState());
        } else {
          emit(ArticlesLoadedState(
              articles: [..._articlesList], message: 'Loading ...'));
        }

        _isFetching = true;
        try {
          List<Article>? localArticles = await _getFromLocalIfNeeded();
          if (localArticles != null) {
            emit(ArticlesLoadedState(
                articles: [..._articlesList], message: 'local stored news'));
          }

          List<Article>? networkArticles;
          try {
            //get network
            if ((_totalResults ?? 10000) > _articlesList.length) {
              //get more articles
              networkArticles = await getFromNetwork();
            } else {
              //stop request no more articles
              // leave networkArticles as null
              emit(ArticlesLoadedState(
                  articles: [..._articlesList],
                  message: 'No more articles to load'));
            }
          } catch (e) {
            emit(ArticlesLoadedState(
                articles: [..._articlesList],
                message: 'No Network connection'));
          }

          if (networkArticles != null) {
            if (_articlesList.isEmpty) {
              //no local and first request
              //add new network articles to local
              addToLocalAndList(networkArticles);
              emit(ArticlesLoadedState(
                  articles: [..._articlesList],
                  message: 'New news were added'));
            } else {
              //we have articals eaither thorough local ones or previos network requests

              //update duplicates and add new ones to _articlesList
              List<Article> newArticals = _getNewArticles(networkArticles);
              if (newArticals.isEmpty) {
                emit(ArticlesLoadedState(
                    articles: [..._articlesList],
                    message: 'Some news were updated'));
              } else {
                addToLocalAndList(newArticals);
                emit(ArticlesLoadedState(
                    articles: [..._articlesList],
                    message: 'New news were added'));
              }
            }
          }
        } catch (e) {
          emit(ArticlesErrorState(message: e.toString()));
        } finally {
          _isFetching = false;
        }
      }
    });
  }

  List<Article> _getNewArticles(List<Article> networkArticles) {
    List<Article> newArticals = [];
    for (var networkArticle in networkArticles) {
      var indexAt = _articlesList.indexOf(networkArticle);
      if (indexAt == -1) {
        //no duplicate found so it is new
        newArticals.add(networkArticle);
      } else {
        //it is duplicate update it in local and list
        _updateLocal(_articlesList[indexAt]);
        _articlesList[indexAt] = networkArticle;
      }
    }
    return newArticals;
  }

  ArticlesState get initialState => ArticlesInitialState();

  int _page = 1;
  int get page => _page;

  int? _totalResults;
  int? get totalResults => _totalResults;

  int _itemsPerPage = 9;
  int get itemsPerPage => _itemsPerPage;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  //can be optemized using maps
  List<Article> _articlesList = [];
  List<Article> get articlesList => [..._articlesList];

  _updateLocal(Article article) async {
    try {
      await localRepository.updateLocalArticle(article);
    } catch (e) {
      await localRepository.addLocalArticles([article]);
    }
  }

  void _resetBlocData() {
    _articlesList = [];
    _isFetching = false;
    _page = 1;
    _totalResults = null;
  }

  Future<List<Article>?> getFromNetwork() async {
    ApiResultModel result =
        await networkRepository.getArticles(_page, _itemsPerPage);
    _totalResults ??= result.totalResults;
    var networkArticles = result.articles;
    _page++;
    return networkArticles;
  }

  void addToLocalAndList(List<Article> newArticals) {
    localRepository.addLocalArticles(newArticals);
    _articlesList.addAll(newArticals);
  }

  Future<List<Article>?> _getFromLocalIfNeeded() async {
    //check local
    if (!localRepository.isEmpty) {
      if (_articlesList.isEmpty) {
        //only get items from local when _articlesList
        //is empty to avoid pagination mixups
        try {
          List<Article>? localArticles = await localRepository.getArticles();
          if (localArticles.length >= _itemsPerPage) {
            _page = localArticles.length ~/ _itemsPerPage;
          }
          _articlesList.addAll(localArticles);
          return localArticles;
        } catch (e) {
          printData('failed in getArticles, e = $e ');
          return null;
        }
      }
    }
    return null;
  }
}
