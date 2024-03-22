
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
            title: Text('Lista Tuplas'),
            onTap: () {
              Navigator.pushNamed(context, '/screen/lista_tuplas');
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


