import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? cep = "77015630";
  
  Future<Map<String, dynamic>?> getEndereco() async{
    http.Response response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if(response.statusCode == 200) {
      return json.decode(response.body);
    } else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CEP finder"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquise o CEP aqui',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder()
              ),
              style: const TextStyle(color: Colors.black, fontSize: 18.0),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onSubmitted: (text){
                setState(() {
                  
                });
              },
            ),
            FutureBuilder<Map<String, dynamic>?>(
              future: getEndereco(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Text("Erro");
                  default:
                    if(snapshot.hasError) {
                      return Container();
                    } else {
                      //Map<String, dynamic>? map = getEndereco().then((value) => null);
                      String endereco = snapshot.data!["uf"] as String;
                      return Text("UF: $endereco");
                    }
                }
              }
            ),
            ],
          ),
        ),
      ),
    );
  }
}