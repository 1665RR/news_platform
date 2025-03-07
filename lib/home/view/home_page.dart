import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_project/news/view/news_overview.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../authentication/bloc/authentication_event.dart';
import '../../news/bloc/news_bloc.dart';
import '../../news/bloc/news_event.dart';
import '../../news/service/news_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final newsRepository = NewsRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () {
              context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) => NewsBloc(newsRepository: newsRepository),
          child: NewsPage(),
        ),
      ),
    );
  }
}
