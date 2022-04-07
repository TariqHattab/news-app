import 'package:hive/hive.dart';

import '../../res/strings.dart';
import '../models/api_model.dart';
import '../models/local_article.dart';

abstract class LocalArticlesRepository {
  Future<void> init();
  bool get isEmpty;
  Future<List<Article>> getArticles();
  Future<void> updateLocalArticle(Article article);
  Future<void> addLocalArticles(List<Article> articles);
  Future<void> clearBox();
}

class LocalArticlesRepositoryImpl implements LocalArticlesRepository {
  late Box<LocalArticle> _localArticleBox;

  @override
  Future<void> init() async {
    _localArticleBox =
        await Hive.openBox<LocalArticle>(AppStrings.articleBoxKey);
  }

  bool get isEmpty => _localArticleBox.isEmpty;

  @override
  Future<List<Article>> getArticles() async {
    _localArticleBox =
        await Hive.openBox<LocalArticle>(AppStrings.articleBoxKey);
    List<LocalArticle> localArticles = _localArticleBox.values.toList();
    List<Article> articles = [];
    for (var la in localArticles) {
      articles.add(Article.fromLocal(la));
    }
    return articles;
  }

  @override
  Future<void> updateLocalArticle(Article article) async {
    LocalArticle localArticle =
        _localArticleBox.values.firstWhere((la) => la.title == article.title);

    await _localArticleBox.put(
      localArticle.key,
      LocalArticle(
        title: article.title,
        urlToImage: article.urlToImage,
        content: article.content,
        publishedAt: article.publishedAt,
      ),
    );
  }

  @override
  Future<void> addLocalArticles(List<Article> articles) async {
    for (var a in articles) {
      LocalArticle localArticle = LocalArticle(
        title: a.title,
        urlToImage: a.urlToImage,
        content: a.content,
        publishedAt: a.publishedAt,
      );

      _localArticleBox.add(localArticle);
    }
  }

  Future<void> clearBox() async {
    await _localArticleBox.clear();
  }
}
