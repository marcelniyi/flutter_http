import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Future fetchPosts() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments/'));
  if (response.statusCode == 200) {
    // return Posts.fromJson(json.decode(response.body));

    var jsonresponse = json.decode(response.body);
    List<Posts> posts = [];
    for(var u in jsonresponse) {
      Posts post = Posts(u["id"], u["email"], u["body"]);
      posts.add(post);
    }
    // print(posts);
    return posts;

  } else {
    throw Exception('Failed to load album');
  }
}





@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Comments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data With Http Call'),
        ),
        body: FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    children: <Widget>[

                      Text("Email : "+snapshot.data[i].email, style: TextStyle(fontSize: 20)),

                      Padding(padding: EdgeInsets.all(20)),

                      Text("Body : "+snapshot.data[i].body, style: TextStyle(fontSize: 20)),

                    ],
                  ),
                );
                }
              );

              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),

      ),
    );
  }

}



class Posts {
  final int id;
  final String email;
  final String body;

  Posts(this.id, this.email, this.body);
}
