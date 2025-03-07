
abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<Map<String, dynamic>> data; // change
  final bool hasReachedMax;

  NewsLoadedState({required this.data,  required this.hasReachedMax});
}

class NewsErrorState extends NewsState {
  final String errorMessage;

  NewsErrorState({required this.errorMessage});
}

class NewsDetailLoadedState extends NewsState {
  final Map<String, dynamic> newsData;

  NewsDetailLoadedState({required this.newsData});
}

class NewsDetailErrorState extends NewsState {
  final String errorMessage;

  NewsDetailErrorState({required this.errorMessage});
}

class NewsDetailLoadingState extends NewsState {}
