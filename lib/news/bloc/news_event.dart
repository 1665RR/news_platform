abstract class NewsEvent {}

class FetchNewsEvent extends NewsEvent {
  final int page;
  final int pageSize;

  FetchNewsEvent({
    required this.page,
    required this.pageSize
  });
}

class FetchNewsByIdEvent extends NewsEvent {
  final String newsId;

  FetchNewsByIdEvent({required this.newsId});
}