import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Desafio Mobilidade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            buildMenuItem(
              icon: Icons.home,
              text: 'Página Inicial',
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
            buildMenuItem(
              icon: Icons.tag_faces,
              text: 'Apelidos',
              onTap: () {
                Navigator.pushNamed(context, '/screen/apelidos');
              },
            ),
            buildMenuItem(
              icon: Icons.message,
              text: 'Posts',
              onTap: () {
                Navigator.pushNamed(context, '/screen/posts');
              },
            ),
            buildMenuItem(
              icon: Icons.people,
              text: 'Usuários',
              onTap: () {
                Navigator.pushNamed(context, '/screen/usuarios');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({IconData? icon, String? text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text ?? '', // Se text for nulo, utiliza uma string vazia
        style: TextStyle(fontSize: 16),
      ),
      onTap: onTap ?? () {}, // Se onTap for nulo, utiliza uma função vazia
    );
  }
}
