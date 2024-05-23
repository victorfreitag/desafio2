import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Principal extends StatefulWidget {
  Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<dynamic>  _data = [];

  //Troquei "_datas" por "_data"//

  @override
  void _carregarDados() async {
    setState(() {
      _buscarDados();

    });
  }

  Future<void> _buscarDados() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
        //'postes' para 'posts', remover o espaço antes do da barra//
      if (response.statusCode == 200) {
        setState(() {
          _data = jsonDecode(response.body);
        });
        print("GET ok HTTP CRUD com Flutter");
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _criarDados() async {
    try {
      final response = await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          //"postes" para "posts", 'aplication' para 'apllications, remover espaço antes da barra'//

          body: jsonEncode(<String, dynamic>{
            'title': 'Flutter HTTP CRUD',
            'body': 'Inserindo dados com HTTP CRUD no Flutter',
            'userId': 1,
          }));

      // 'tilee' para  'title', trocar 'get' para 'post'//

      if (response.statusCode == 201) {
        _buscarDados();
        print("POST ok HTTP CRUD com Flutter");
      } else {
        throw Exception('Failed to create data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _alterarDados(int id) async {
    try {
      final response = await http.put(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),

          //'i' para 'id',//
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'titles': 'Flutter HTTP CRUD',
            'body': 'Update ok HTTP CRUD com Flutter',
          }));

      if (response.statusCode == 200) {
        _buscarDados();
        print("Update ok HTTP CRUD com Flutter");
      } else {
        throw Exception('Failed to update data');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _deletarDados(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

      //'d' para 'id',remover espaço antes da barra', trocar 'post' por delete//
      if (response.statusCode == 200) {
        print("DELETE ok HTTP CRUD com Flutter");
        _buscarDados();
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CONSUMIR API COM HTTP"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          final data = _data[index];
          return ListTile(
            title: Text(data['title'],
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold)),
            subtitle: Text(
              data['body'],
              style: TextStyle(fontSize: 10),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _alterarDados(data['id']),
                ),
                //inserir '=> _alterarDados(data['id'])' no OnPressed//

                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletarDados(data['id']),
                ),
                //=> _deletarDados(data['id'])' no OnPressed//
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarDados,
        tooltip: 'Create',
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        elevation: 5,
      ),
    );
  }
}
