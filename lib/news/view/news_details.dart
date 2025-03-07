import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../service/news_service.dart';

class NewsPage extends StatefulWidget {
  final NewsRepository newsRepository = NewsRepository();

  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late ScrollController _scrollController;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    context
        .read<NewsBloc>()
        .add(FetchNewsEvent(page: _currentPage, pageSize: _pageSize));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        context
            .read<NewsBloc>()
            .add(FetchNewsEvent(page: _currentPage, pageSize: _pageSize));
        _currentPage++;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsBloc(newsRepository: widget.newsRepository),
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsErrorState) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is NewsLoadedState) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.data.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.data.length)
                  return Center(child: CircularProgressIndicator());

                return ListTile(
                  title: Text(state.data[index]['title']),
                  subtitle: Text(state.data[index]['description']),
                );
              },
            );
          }
          return Center(child: Text('No news available'));
        },
      ),
    );
  }
}
