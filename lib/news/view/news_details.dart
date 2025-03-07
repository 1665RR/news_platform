import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../service/news_service.dart';

class NewsDetailPage extends StatelessWidget {
  final String newsId;

  NewsDetailPage({required this.newsId});
  final newsRepository = NewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News Detail")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: newsRepository.getNewsById(newsId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No news details available'));
          } else {
            final newsItem = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (newsItem['pictures'] != null && newsItem['pictures'].isNotEmpty)
                    Image.network(newsItem['pictures'][0]['filePath']),
                  const SizedBox(height: 10),
                  Text(
                    newsItem['content'] ?? 'No content available',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Created on: ${newsItem['creationDateUtc']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  if (newsItem['categoryTitle'] != null)
                    Text(
                      'Category: ${newsItem['categoryTitle']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
