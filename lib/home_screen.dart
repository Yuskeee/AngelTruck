import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'consts.dart';

import 'nav_bar.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Home screen with the logo and the button to start the video analysis
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {},
                child: const Text('Start video analysis'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kPrimaryColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  upload(File('C:\\Users\\Yuske\\Downloads\\lapti.mp4'));
                },
                child: const Text('Upload'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kPrimaryColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
