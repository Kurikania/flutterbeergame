import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterbeergame/models/beer_model.dart';
import 'package:flutterbeergame/models/user_model.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class Items {
  Map<String, dynamic> getItems() {
    String jsonData =
        '{ "item1": "value1","item2": "value2","item3": "value3"}';

    Map<String, dynamic> data = jsonDecode(jsonData);
    return data;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _userImage(String url, double height) {
    return Container(
      constraints: BoxConstraints.tightFor(height: height),
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url,
      ),
    );
  }

  Widget _renderInfo(BuildContext context, User user) {
    var data1 = jsonEncode(user.toJson());
    Map<String, dynamic> data = jsonDecode(data1);
    return ListView.builder(
      itemCount: data.keys.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        if (data.keys.elementAt(index).toString() != "avatar" &&
            data.keys.elementAt(index).toString() != "uid" &&
            data.keys.elementAt(index).toString() != "id") {
          return ListTile(
              dense: true,
              leading: const Icon(
                Icons.face,
                color: Colors.yellow,
                size: 8.0,
              ),
              title: Text(data.values.elementAt(index).toString()));
        } else {
          return Container();
        }
      }),
    );
  }

  _renderInfoBeer(BuildContext context, Beer beer) {
    var data1 = jsonEncode(beer.toJson());
    Map<String, dynamic> data = jsonDecode(data1);
    return ListView.builder(
      itemCount: data.keys.length,
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        if (data.keys.elementAt(index).toString() != "uid" &&
            data.keys.elementAt(index).toString() != "id") {
          return ListTile(
            dense: true,
            title: Text(data.values.elementAt(index).toString()),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  List<Widget> _renderBody(BuildContext buildContext, User user) {
    final result = <Widget>[];
    result.add(_userImage(user.avatar, 170));
    result.add(_renderInfo(buildContext, user));
    // result.add(TextButton(onPressed: () => {}, child: Text("New User")));

    return result;
  }

  _renderBodyBeer(BuildContext buildContext, Beer beer) {
    final result = <Widget>[];
    result.add(_renderInfoBeer(buildContext, beer));
    result.add(ElevatedButton(
        onPressed: () async {
          Future<Beer> result = fetchBeer();
          setState(() {
            futureBeer = result;
          });
        },
        child: Text("New Beer")));
    return result;
  }

  late Future<User> futureUser;
  late Future<Beer> futureBeer;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    futureBeer = fetchBeer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beer app"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Card(
                        child: Column(
                          children: _renderBody(context, snapshot.data!),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            Center(
                child: FutureBuilder<Beer>(
              future: futureBeer,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Card(
                      child: Column(
                        children: _renderBodyBeer(context, snapshot.data!),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ))
          ],
        ),
      ),
    );
  }
}
