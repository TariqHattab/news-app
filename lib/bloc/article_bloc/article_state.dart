import 'package:equatable/equatable.dart';

import '../../data/models/api_model.dart';

abstract class ArticlesState extends Equatable {}

class ArticlesInitialState extends ArticlesState {
  @override
  List<Object> get props => [];
}

class ArticlesLoadingState extends ArticlesState {
  @override
  List<Object> get props => [];
}

class ArticlesLoadedState extends ArticlesState {
  final List<Article> articles;
  String message;
  ArticlesLoadedState({required this.articles, this.message = ''});

  @override
  List<Object> get props => [articles, message];
}

class ArticlesErrorState extends ArticlesState {
  final String message;
  ArticlesErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class ShowMessageState extends ArticlesState {
  final String message;
  ShowMessageState({required this.message});
  @override
  List<Object> get props => [message];
}

class ClearedLocalArticalsState extends ArticlesState {
  final List<Article> articles;
  ClearedLocalArticalsState({this.articles = const []});
  @override
  List<Object> get props => [articles];
}
