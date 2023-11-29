import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'consts.dart';
import 'nav_bar.dart';

import 'map_screen.dart';
import 'cam_screen.dart';

// Send data to the server and get the response
upload(File imageFile) async {
  // open a bytestream
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse("http://152.67.52.107:5000/videoanalisys");

  // create multipart request
  var request = http.MultipartRequest("POST", uri);

  // multipart that takes file
  var multipartFile = http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  // add file to multipart
  request.files.add(multipartFile);

  // send
  print("sending video");
  var response = await request.send();
  print(response.statusCode);

  // listen for response
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
        body: Column(
          children: [
            const MapScreen(),
            ElevatedButton(
              onPressed: () {
                upload(File('C:\\Users\\Yuske\\Downloads\\lapti.mp4'));
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
