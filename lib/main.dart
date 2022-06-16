import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fetchAlbum() async {
  String iTOKEN = "998f2eb4ce4bb1fdfab18402d0035bd6";
  String iCIDADE = "3477";
  int iTIPOCONSULTA = 1;


  final response = await http.get(Uri.parse("https://apiadvisor.climatempo.com.br/api/v1/weather/locale/" + iCIDADE + "/current?token=" + iTOKEN));
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<dynamic> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima tempo - SP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clima tempo - SP'),
        ),
        body: Center(
          child: FutureBuilder<dynamic>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(snapshot.data!['name'], style: DefaultTextStyle
                        .of(context)
                        .style
                        .apply(fontSizeFactor: 2.0)),
                    Text(snapshot.data!['state'], style: DefaultTextStyle
                        .of(context)
                        .style
                        .apply(fontSizeFactor: 1.2)),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(snapshot.data!['data']['temperature'].toString() + "°",
                        style: DefaultTextStyle
                            .of(context)
                            .style
                            .apply(fontSizeFactor: 3.5)),
                    Padding(padding: EdgeInsets.only(top: 60)),
                    Image.asset("images/realistic/250px/" + snapshot.data!['data']['icon'] + ".jpg"),
                    Text("Humidade " + snapshot.data!['data']['humidity'].toString(),
                        style: DefaultTextStyle
                            .of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text("Velocidade do vento " + snapshot.data!['data']['wind_velocity'].toString(),
                        style: DefaultTextStyle
                            .of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}



