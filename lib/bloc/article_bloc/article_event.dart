//only one event for fetching from api
import 'package:equatable/equatable.dart';

abstract class ArticlesEvent extends Equatable {}

class FetchArticlesEvent extends ArticlesEvent {
  @override
  List<Object> get props => [];
}

class RegisterRepoEvent extends ArticlesEvent {
  @override
  List<Object> get props => [];
}

class ClearLocalArticlesEvent extends ArticlesEvent {
  @override
  List<Object> get props => [];
}
