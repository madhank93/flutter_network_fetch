import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterappnetworkfetch/model/beer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top beers',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Beer> _beers = <Beer>[];

  @override
  void initState() {
    super.initState();
    listenForBeers();
  }

  void listenForBeers() async {
    final Stream<Beer> stream = await getBeers();
    stream.listen((Beer beer) => setState(() => _beers.add(beer)));
  }

  Future<Stream<Beer>> getBeers() async {
    final String url = 'https://api.punkapi.com/v2/beers';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((data) => (data as List))
        .map((data) => Beer.fromJSON(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top beers'),
      ),
      body: ListView.builder(
        itemCount: _beers.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(_beers[index].name),
                subtitle: Text(_beers[index].tagLine),
                leading: Container(
                  margin: EdgeInsets.only(left: 6.0),
                  child: Image.network(
                    _beers[index].imageUrl,
                    height: 50.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}
