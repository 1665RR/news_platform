import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_project/news/service/news_service.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc({required NewsRepository newsRepository})
      : _newsRepository = newsRepository,
        super(NewsInitialState()) {
    on<FetchNewsEvent>(_onFetchNewsEvent);
    on<FetchNewsByIdEvent>(_onFetchNewsByIdEvent);
  }

  Future<void> _onFetchNewsEvent(
      FetchNewsEvent event,
      Emitter<NewsState> emit,
      ) async {
    final currentState = state;

    List<Map<String, dynamic>> existingNews = [];
    bool hasReachedMax = false;

    if (currentState is NewsLoadedState) {
      existingNews = currentState.data;
      hasReachedMax = currentState.hasReachedMax;
    }

    // Avoid unnecessary API calls if we already reached the end
    if (hasReachedMax) return;

    try {
      final data = await _newsRepository.postNews(
        page: event.page,
        pageSize: event.pageSize,
      );

      if (data != null) {
        if (data.isEmpty) {
          emit(NewsLoadedState(
            data: existingNews,
            hasReachedMax: true,
          ));
        } else {
          final updatedNews = [...existingNews, ...data];
          emit(NewsLoadedState(
            data: updatedNews,
            hasReachedMax: data.length < event.pageSize,
          ));
        }
      } else {
        emit(NewsErrorState(errorMessage: 'Failed to fetch news'));
      }
    } catch (error) {
      emit(NewsErrorState(errorMessage: 'Error: $error'));
    }
  }


  Future<void> _onFetchNewsByIdEvent(
      FetchNewsByIdEvent event,
      Emitter<NewsState> emit,
      ) async {
    emit(NewsDetailLoadingState());

    try {
      final data = await _newsRepository.getNewsById(event.newsId);

      if (data != null) {
        emit(NewsDetailLoadedState(newsData: data));
      } else {
        emit(NewsDetailErrorState(errorMessage: 'Failed to fetch news by ID'));
      }
    } catch (error) {
      emit(NewsDetailErrorState(errorMessage: 'Error: $error'));
    }
  }
}
