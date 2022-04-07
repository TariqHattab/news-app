import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/article_bloc/article_bloc.dart';
import 'bloc/article_bloc/article_event.dart';
import 'bloc/lang_bloc/lang_bloc.dart';
import 'bloc/lang_bloc/lang_event.dart';
import 'data/models/local_article.dart';
import 'data/repositories/article_repo.dart';
import 'data/repositories/lang_repo.dart';
import 'data/repositories/local_article_repo.dart';
import 'res/strings.dart';
import 'views/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LocalArticleAdapter());
  await Hive.openBox<LocalArticle>(AppStrings.articleBoxKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => NetworkArticlesRepositoryImpl()),
        RepositoryProvider(create: (context) => LangRepositoryImpl()),
        RepositoryProvider(create: (context) => LocalArticlesRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => ArticlesBloc(
              networkRepository:
                  RepositoryProvider.of<NetworkArticlesRepositoryImpl>(context),
              localRepository:
                  RepositoryProvider.of<LocalArticlesRepositoryImpl>(context),
            )..add(RegisterRepoEvent()),
          ),
          BlocProvider(
            create: (BuildContext context) => LangBloc(
                repository: RepositoryProvider.of<LangRepositoryImpl>(context))
              ..add(RegisterLangEvent()),
          )
        ],
        child: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: context.watch<LangBloc>().locale,
      title: 'Flutter News App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}
