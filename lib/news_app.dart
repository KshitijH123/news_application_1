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
    final url =
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
      body: FutureBuilder(
          future: fetchNews(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${snapshot.data!.articles![index].urlToImage}"),
                  ),
                  title: Text("${snapshot.data!.articles![index].title}"),
                  subtitle:
                      Text("${snapshot.data!.articles![index].description}"),
                );
              },
              itemCount: snapshot.data!.articles!.length,
            );
          }),
    );
  }
}
