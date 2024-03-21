
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Página Inicial'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            title: Text('Apelidos Salvos'),
            onTap: () {
              Navigator.pushNamed(context, '/screen/apelidos');
            },
          ),
          ListTile(
            title: Text('Posts'),
            onTap: () {
              Navigator.pushNamed(context, '/screen/posts');
            },
          ),
          ListTile(
            title: Text('Usuários'),
            onTap: () {
              Navigator.pushNamed(context, '/screen/usuarios');
            },
          ),
        ],
      ),
    );
  }
}


