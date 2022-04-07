import 'package:hive/hive.dart';

part 'local_article.g.dart';

@HiveType(typeId: 1)
class LocalArticle extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  String? urlToImage;

  @HiveField(2)
  String? publishedAt;

  @HiveField(3)
  String? content;

  LocalArticle({
    required this.title,
    this.urlToImage,
    this.content,
    this.publishedAt,
  });
}
