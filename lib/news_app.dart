import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_application_1/news_model.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  Future<NewsModel> fetchNews() async {
    const url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-08-06&sortBy=publishedAt&apiKey=0c0db177b5a14ec2a75c4566c7d0bf0b";
    var responce = await http.get(Uri.parse(url));

    if (responce.statusCode == 200) {
      final result = jsonDecode(responce.body);
      return NewsModel.fromJson(result);
    } else {
      return NewsModel();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        centerTitle: true,
      ),
      body: FutureBuilder<NewsModel?>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No news available'));
          } else {
            final news = snapshot.data!;
            return ListView.builder(
              itemCount: news.articles?.length ?? 0,
              itemBuilder: (context, index) {
                final article = news.articles![index];
                return ListTile(
                  leading: article.urlToImage != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(article.urlToImage!),
                        )
                      : null,
                  title: Text(article.title ?? 'No title'),
                  subtitle: Text(article.description ?? 'No description'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
