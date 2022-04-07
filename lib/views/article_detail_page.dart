import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/lang_bloc/lang_bloc.dart';
import '../data/models/api_model.dart';
import '../res/common_functions.dart';

class ArticlesDetailPage extends StatelessWidget {
  final Article article;

  ArticlesDetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    var herotag =
        article.title + context.read<LangBloc>().locale.toLanguageTag();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(tr(context).detailPageTitle),
      ),
      body: Column(
        children: [
          if (article.urlToImage != null)
            Container(
              child: Hero(
                tag: herotag,
                child: Image.network(article.urlToImage!,
                    errorBuilder: (context, exception, stackTrace) {
                  return Center(child: Text('error in url'));
                }),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    article.title,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    article.publishedAt ?? 'no publishedAt',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    article.content ?? "no content",
                    style: TextStyle(
                      color: Colors.grey[800],
                      //fontWeight: FontWeight,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
