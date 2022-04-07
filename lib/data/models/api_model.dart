import 'package:equatable/equatable.dart';
import 'package:flutter_newsapp/data/models/local_article.dart';

class ApiResultModel {
  String? status;
  int? totalResults;
  List<Article>? articles;

  ApiResultModel({this.status, this.totalResults, this.articles});

  ApiResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = [];
      json['articles'].forEach((v) {
        articles!.add(new Article.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.articles != null) {
      data['articles'] = this.articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Article extends Equatable {
  late String title;

  String? urlToImage;
  String? publishedAt;
  String? content;

  Article(
      {required this.title, this.urlToImage, this.publishedAt, this.content});

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }
  Article.fromLocal(LocalArticle localArticle) {
    title = localArticle.title;
    urlToImage = localArticle.urlToImage;
    publishedAt = localArticle.publishedAt;
    content = localArticle.content;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;

    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }

  //had to use title as primary because no id is returned from api and it was always not null
  @override
  List<Object?> get props => [title];
}
