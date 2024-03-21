import 'package:flutter/material.dart';
import 'package:desafio_teia/screen/posts.dart';
import 'package:desafio_teia/screen/usuarios.dart';
import 'package:desafio_teia/screen/menu.dart'; 
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isButtonEnabled = false;
  String _validationMessage = '';
  String? _receivedLink; // Variável para armazenar o link recebido

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener(); // Inicialize o listener de deep link
  }

  // Função para inicializar o listener de deep link
  Future<void> _initDeepLinkListener() async {
    // Adicione um listener para os links recebidos
    await initUniLinks();
    // Defina o callback para manipular os links recebidos
    // ignore: deprecated_member_use
    getLinksStream().listen((String? link) {
      if (!mounted) return;
      setState(() {
        _receivedLink = link; // Salve o link recebido
      });
    }, onError: (dynamic error) {
      print('Erro ao receber link: $error');
    });
  }

  void _validateNickname(String value) {
    setState(() {
      _isButtonEnabled = RegExp(r'^[a-zA-Z0-9]{3,20}$').hasMatch(value);
    });
  }

  void _saveNickname() {
    if (_isButtonEnabled) {
      // Apelido válido, salvar
      setState(() {
        _validationMessage = 'Apelido válido! Salvo: ${_nicknameController.text}';
      });
    } else {
      // Apelido inválido
      setState(() {
        _validationMessage = 'Apelido inválido! Deve conter 3-20 caracteres alfanuméricos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      drawer: MenuScreen(), // Utiliza o componente do menu
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_receivedLink != null) // Se um link foi recebido, exiba-o
              Text('Link recebido: $_receivedLink'),  
            TextField(
              controller: _nicknameController,
              onChanged: _validateNickname,
              decoration: InputDecoration(
                labelText: 'Apelido',                
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveNickname();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_validationMessage),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Salvar'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  initUniLinks() {}
}