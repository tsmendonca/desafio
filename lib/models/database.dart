import 'package:desafio_teia/models/users.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  late MySqlConnection _connection;
  late bool _isConnected = false;

  DatabaseHelper() {
    _connect().then((_) {
      _isConnected = true;
    });
  }


  // Configurar a conexão local para o banco de dados 
  Future<void> _connect() async {
    final settings = ConnectionSettings(
      host: '',
      port: 3306,
      user: '',
      password: '',
      db: '',
    );

    try {
      _connection = await MySqlConnection.connect(settings);
      print('Conexão com o banco de dados estabelecida com sucesso!');
    } catch (e) {
      print('Erro ao estabelecer conexão com o banco de dados: $e');
    }
  }

  Future<bool> insertUser(int pat, String nickname) async {
    // Garante que a conexão esteja estabelecida antes de executar a operação
    await _waitForConnection();
    
    try {
      var sql = 'SELECT COUNT(*) as count FROM users WHERE nickname = ?';
      Results results = await _connection.query(sql, [nickname]);
      var count = results.first.fields['count'] as int;

      if (count > 0) {
        return false; // Retorna false se o nickname já existir
      }

      // Insere os dados do usuário
      await _connection.query(
        'INSERT INTO users (pat, nickname) VALUES (?, ?)',
        [pat, nickname],
      );
      
      // Retorne true para indicar que o usuário foi inserido com sucesso
      return true;
    } catch (e) {
      print('Erro ao inserir usuário: $e');
      return false; // Retorne false se ocorrer um erro
    }
  }

  Future<List<User>> getAllUsers() async {
    // Garante que a conexão esteja estabelecida antes de executar a operação
    await _waitForConnection();
    
    try {
      Results results = await _connection.query('SELECT pat, nickname FROM users');
      List<User> users = results.map((r) => User(
        pat: r[0] as int, 
        nickname: r[1] as String, 
      )).toList();
      return users;
    } catch (e) {
      print('Erro ao recuperar usuários: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<void> _waitForConnection() async {
    // Aguarda até que a conexão esteja estabelecida
    while (!_isConnected) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> closeConnection() async {
    await _connection.close();
  }
}
