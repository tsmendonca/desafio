import 'package:flutter/material.dart';
import 'package:desafio_teia/screen/posts.dart';
import 'package:desafio_teia/screen/usuarios.dart';
import 'package:desafio_teia/screen/menu.dart';
import 'package:desafio_teia/screen/apelidos.dart'; 
import 'package:desafio_teia/models/database.dart'; 
import 'package:desafio_teia/models/users.dart'; 
import 'package:uni_links/uni_links.dart';
import 'dart:async';


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
        '/screen/usuarios': (context) => UsuariosScreen(),
        '/screen/posts': (context) => PostsScreen(),
        '/screen/apelidos': (context) => ApelidosScreen(),
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
  String? _receivedLink;
  int? _receivedPat;
  late DatabaseHelper _databaseHelper;
 
  

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(); // Inicializa o DatabaseHelper
   _initDeepLinkListener();
   _processInitialLink();
   // Caso necessário para testar pelo emulador retire o comentário da linha a seguir 
   // _receivedPat = 97; // Valor simulado para _receivedPat
  }

  Future<void> _initDeepLinkListener() async {
    await initUniLinks();
    getLinksStream().listen((String? link) {
      if (!mounted) return;
      setState(() {
        _receivedLink = link;
        _processLink(link);
      });
    }, onError: (dynamic error) {
      print('Erro ao receber link: $error');
    });
  }

  void _processLink(String? link) {
    if (link != null && link.contains('pat=')) {
      final uri = Uri.parse(link);
      final patValue = uri.queryParameters['pat'];
      if (patValue != null) {
        setState(() {
          _receivedPat = int.tryParse(patValue);
        });
      }
    }
  }

  Future<void> _processInitialLink() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _processLink(initialLink);
      }
    } catch (e) {
      print('Erro ao processar o link inicial: $e');
    }
  }

  void _validateNickname(String value) {
    setState(() {
      _isButtonEnabled = RegExp(r'^[a-zA-Z0-9]{3,20}$').hasMatch(value);
    });
  }

    Future<void> _saveNickname() async {
  if (_receivedPat == null) {
    setState(() {
      _validationMessage = 'O PAT não foi recebido. Não é possível salvar o apelido.';
    });
  } else if (_isButtonEnabled) {
    bool userInserted = await _databaseHelper.insertUser(_receivedPat!, _nicknameController.text);

    if (userInserted) {
      setState(() {
        _validationMessage = 'Apelido salvo com sucesso!';
      });
    } else {
      setState(() {
        _validationMessage = 'Erro ao salvar: O nickname ${_nicknameController.text} já existe.';
      });
    }
  } else {
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
      drawer: MenuScreen(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_receivedPat != null)
              TextFormField(
                initialValue: _receivedPat.toString(),
                decoration: InputDecoration(labelText: 'PAT'),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              onChanged: _validateNickname,
              decoration: InputDecoration(labelText: 'Apelido'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNickname,
              child: Text('Salvar'),
            ),
            SizedBox(height: 20),
            Text(_validationMessage),
          ],
        ),
      ),
    );
  }

  initUniLinks() {}
}