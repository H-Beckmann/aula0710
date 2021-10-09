import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class HomePageDio extends StatefulWidget {
  const HomePageDio({ Key? key }) : super(key: key);

  @override
  _HomePageDioState createState() => _HomePageDioState();
}

class _HomePageDioState extends State<HomePageDio> {

  String cep = "77015630";

  Future<Map> _getEndereco() async{
    var response = await Dio().get("https://viacep.com.br/ws/$cep/json/");
    return response.data;
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
            FutureBuilder<Map>(
              future: _getEndereco(),
              builder: (context, snapshot){
                return snapshot.connectionState == ConnectionState.waiting ?
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ) :
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text("UF: ${snapshot.data!["uf"]}"),
                    ],
                  ),
                );
              }
            ),
            ],
          ),
        ),
      ),
    );
  }
}