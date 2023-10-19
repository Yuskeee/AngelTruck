import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'consts.dart';
import 'nav_bar.dart';

Future<String> fetchData() async {
  final response = await http.get(Uri.parse('http://152.67.52.107:5000'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angel Truck',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kPrimaryColor,
      )),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Angel Truck',
              style: TextStyle(color: Color.fromARGB(255, 44, 44, 44))),
        ),
        bottomNavigationBar: const NavBar(),
        body: Center(
          child: FutureBuilder<String>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
