import 'package:flutter/material.dart';
import 'package:desafio_teia/models/database.dart'; // Importe o arquivo database.dart
import 'package:desafio_teia/models/users.dart'; // Importe o arquivo users.dart

class ListaTuplasScreen extends StatefulWidget {
  @override
  _ListaTuplasScreenState createState() => _ListaTuplasScreenState();
}

class _ListaTuplasScreenState extends State<ListaTuplasScreen> {
  late List<User> _users = []; // Lista para armazenar os usuários recuperados do banco de dados

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase(); // Chama a função para recuperar os dados do banco de dados
  }

  Future<void> _fetchDataFromDatabase() async {
    try {
      // Recupera os usuários do banco de dados usando DatabaseHelper
      List<User> users = await DatabaseHelper().getAllUsers();
      setState(() {
        _users = users; // Atualiza o estado com os usuários recuperados
      });
    } catch (e) {
      print('Erro ao recuperar dados do banco de dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tuplas'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('PAT: ${_users[index].pat}, Nickname: ${_users[index].nickname}'),
          );
        },
      ),
    );
  }
}
