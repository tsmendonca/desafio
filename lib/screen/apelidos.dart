import 'package:flutter/material.dart';
import 'package:desafio_teia/models/database.dart';
import 'package:desafio_teia/models/users.dart';

class ApelidosScreen extends StatefulWidget {
  @override
  _ApelidosScreenState createState() => _ApelidosScreenState();
}

class _ApelidosScreenState extends State<ApelidosScreen> {
  late List<User> _users = [];
  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final databaseHelper = DatabaseHelper();
    final users = await databaseHelper.getAllUsers();

    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Apelidos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum apelido encontrado.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            'Apelido: ${user.nickname}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('PAT: ${user.pat}'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
