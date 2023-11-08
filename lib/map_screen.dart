import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

import 'consts.dart';

Future<String> fetchData() async {
  final response =
      await http.get(Uri.parse('http://152.67.52.107:5000/getmap'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the response.
    return base64Encode(response.bodyBytes);
    // var document = parse(response.body);
    // dom.Element? link = document.querySelector('img');
    // String? imageLink = link != null ? link.attributes['src'] : '';
    // return imageLink!;
    //
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<String> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<String>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              base64Decode(snapshot.data!),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.fill,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
