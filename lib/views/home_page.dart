import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/article_bloc/article_bloc.dart';
import '../bloc/article_bloc/article_event.dart';
import '../bloc/article_bloc/article_state.dart';
import '../bloc/lang_bloc/lang_bloc.dart';
import '../bloc/lang_bloc/lang_event.dart';
import '../bloc/lang_bloc/lang_state.dart';
import '../data/models/api_model.dart';
import '../res/common_functions.dart';
import 'article_detail_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ArticlesBloc articleBloc;
  late LangBloc _langBloc;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    articleBloc = BlocProvider.of<ArticlesBloc>(context);
    _langBloc = BlocProvider.of<LangBloc>(context);

    articleBloc.add(FetchArticlesEvent());
    _scrollController.addListener(_loadMoreArticles);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreArticles);
    _scrollController.dispose();
    super.dispose();
  }

  _loadMoreArticles() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        !context.read<ArticlesBloc>().isFetching) {
      context.read<ArticlesBloc>().add(FetchArticlesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(tr(context).listPageTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              articleBloc.add(ClearLocalArticlesEvent());
            },
          ),
          BlocBuilder<LangBloc, LangState>(
            builder: (context, state) {
              if (state is LangInitialState) {
                return _buildIconButton(state.locale);
              }
              if (state is LangLoadingState) {
                return _buildLoading();
              }
              if (state is LangLoadedState) {
                return _buildIconButton(state.locale);
              } else {
                printData('state not found');
                return Container();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: BlocConsumer<ArticlesBloc, ArticlesState>(
          listener: (context, state) {
            if (state is ArticlesErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is ArticlesLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Loading ...'),
                ),
              );
            } else if (state is ArticlesLoadedState) {
              _clearSnackBars(context, state);
            }
          },
          builder: (context, state) {
            if (state is ArticlesInitialState) {
              return _buildLoading();
            } else if (state is ArticlesLoadingState) {
              return _buildLoading();
            } else if (state is ClearedLocalArticalsState) {
              return _buildClearedLocalsPage();
            } else if (state is ArticlesLoadedState) {
              return _buildArticlesList(state.articles);
            } else if (state is ArticlesErrorState) {
              return _buildErrorUi(state.message);
            } else {
              return Container(child: Text('no article state found'));
            }
          },
        ),
      ),
    );
  }

  Center _buildClearedLocalsPage() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                'cleared all local data , send new request?',
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  articleBloc.add(FetchArticlesEvent());
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.orange,
                ))
          ],
        ),
      ),
    );
  }

  void _clearSnackBars(BuildContext context, ArticlesLoadedState state) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (state.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      }
    });
  }

  IconButton _buildIconButton(Locale locale) {
    return IconButton(
      icon: Text(
        locale == Locale('en') ? 'EN' : 'AR',
        style: TextStyle(fontSize: 19),
      ),
      onPressed: () {
        _langBloc.add(ToggleLangEvent());
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: SpinKitChasingDots(
        color: Colors.orangeAccent,
        size: 100.0,
      ),
    );
  }

  Widget _buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildArticlesList(articlesList) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: articlesList.length,
      itemBuilder: (ctx, index) {
        var herotag = (articlesList[index].title) +
            context.read<LangBloc>().locale.toLanguageTag();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Container(
              child: Row(
                children: [
                  SizedBox(
                    height: 70.0,
                    width: 70.0,
                    child: articlesList[index].urlToImage == null
                        ? Center(
                            child: Text(
                            'no image url',
                            textAlign: TextAlign.center,
                          ))
                        : Hero(
                            tag: herotag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                articlesList[index].urlToImage!,
                                errorBuilder: (context, exception, stackTrace) {
                                  return Center(child: Text('error in url'));
                                },
                                fit: BoxFit.cover,
                                height: 70.0,
                                width: 70.0,
                              ),
                            ),
                          ),
                  ),
                  // CachedNetworkImage(
                  //   imageUrl: articlesList[index].urlToImage!,
                  //   placeholder: (context, url) =>
                  //       Center(child: CircularProgressIndicator()),
                  //   errorWidget: (context, url, error) =>
                  //       Icon(Icons.error),
                  //   fit: BoxFit.cover,
                  //   height: 70.0,
                  //   width: 70.0,
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(articlesList[index].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle()),
                  ),
                ],
              ),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                gradient: new LinearGradient(
                    colors: [
                      Color.fromARGB(255, 238, 194, 156),
                      Color.fromARGB(255, 255, 238, 221)
                    ],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0)),
              ),
            ),
            onTap: () {
              _navigateToDetailPage(context, articlesList[index]);
            },
          ),
        );
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, Article article) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ArticlesDetailPage(
        article: article,
      );
    }));
  }
}
