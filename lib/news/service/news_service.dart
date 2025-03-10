import 'dart:convert';

import '../../globals/constants/api_data_routes.dart';
import '../../http/api_service.dart';

class NewsRepository {
  Future<List<Map<String, dynamic>>?> postNews({
    required int page,
    required int pageSize
  }) async {
    final body = jsonEncode({
      'page': page,
      'pageSize': pageSize,
    });

    try {
      final response = await ApiService.post(
        ApiRoutes.news,
        body: body,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['result'] != null && data['result']['results'] != null) {
          return List<Map<String, dynamic>>.from(data['result']['results']);
        } else {
          return [];
        }
      } else {
        if (data['errors'] != null &&
            data['errors'] is List &&
            (data['errors'] as List).isNotEmpty) {
          throw Exception('${data['errors'].join(", ")}');
        }
      }
    } catch (error) {
      throw Exception('Failed to load news.');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getNewsById(String newsId) async {
    final response = await ApiService.get(
      "${ApiRoutes.news}/$newsId",
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['result'] != null) {
        return jsonResponse['result'];
      } else {
        throw Exception('No result found in response');
      }
    } else {
      throw Exception('Failed to load news');
    }
  }
}
