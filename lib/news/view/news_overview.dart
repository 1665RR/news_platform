import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import 'news_details.dart';
import 'news_tile.dart';

class NewsPage extends StatefulWidget {
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final newsBloc = context.read<NewsBloc>();
      if (newsBloc.state is NewsLoadedState && !(newsBloc.state as NewsLoadedState).hasReachedMax) {
        _currentPage++;
        newsBloc.add(FetchNewsEvent(page: _currentPage, pageSize: _pageSize));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsInitialState) {
          context.read<NewsBloc>().add(FetchNewsEvent(page: _currentPage, pageSize: _pageSize));
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NewsLoadingState && _currentPage == 1) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NewsErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              title: const Text("Error"),
              description: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
              type: ToastificationType.error,
              animationDuration: const Duration(milliseconds: 400),
            );
          });
          return const SizedBox();
        }

        if (state is NewsLoadedState) {
          if (state.data.isEmpty && _currentPage == 1) {
            return const Center(child: Text('No news available'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.data.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.data.length) {
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              var newsItem = state.data[index];

              return NewsTile(
                title: newsItem['title'],
                description: newsItem['description'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(newsId: newsItem['id']),
                    ),
                  );
                },
              );
            },
          );
        }

        return const Center(child: Text('No news available'));
      },
    );
  }
}
