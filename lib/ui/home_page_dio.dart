import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePageDio extends StatefulWidget {
  const HomePageDio({Key? key}) : super(key: key);

  @override
  _HomePageDioState createState() => _HomePageDioState();
}

class _HomePageDioState extends State<HomePageDio> {
  String? cep;

  final _textController = TextEditingController();
  final _focus = FocusNode();

  Future<Map> _getEndereco() async {
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
        actions: <Widget>[
          IconButton(onPressed: (){
            setState(() {
              cep = null;
              _textController.clear();
            });
          }, icon: const Icon(Icons.delete_outline_rounded))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                    labelText: 'Pesquise o CEP aqui',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder()),
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onSubmitted: (text) {
                  setState(() {
                    cep =text;
                  });
                },
              ),
              _getCEP()
            ],
          ),
        ),
      ),
    );
  }

  _getCEP() {
    if((cep !=null && cep!.length<8) || (cep !=null && cep!.length>8)){
      FocusScope.of(context).requestFocus(_focus);
      return Container(
        padding: const EdgeInsets.all(20.0),
        child:const Text(
          "Cep Inválido"
        )
      );
    }else if(cep==null || cep!.isEmpty){
      return Container(
        padding: const EdgeInsets.all(20.0),
        child:const Text(
          "Sem Cep"
        )
      );
    }else{
    return FutureBuilder<Map>(
      future: _getEndereco(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
          ? const Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          )
          : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(snapshot.data?["uf"] == null)
                  const Text("Cep Inválido")
                else
                  snapshot.data?["uf"] == null?const Text(""):Text(
                    "Logradouro: ${snapshot.data!["logradouro"]}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  if(snapshot.data?["complemento"].isNotEmpty)
                    snapshot.data?["uf"] == null?const Text(""):Text("Complemento: ${snapshot.data!["complemento"]}"),
                  snapshot.data?["uf"] == null?const Text(""):Text("Bairro: ${snapshot.data!["bairro"]}"),
                  snapshot.data?["uf"] == null?const Text(""):Text("Localidade: ${snapshot.data!["localidade"]}"),
                  snapshot.data?["uf"] == null?const Text(""):Text("UF: ${snapshot.data!["uf"]}"),
              ],
            ),
          );
      });
  }
  }
}
