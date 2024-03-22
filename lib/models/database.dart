import 'package:desafio_teia/models/users.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  late MySqlConnection _connection;

  DatabaseHelper() {
    _connect();
  }

  Future<void> _connect() async {
    final settings = ConnectionSettings(
      host: 'goias.app',
      port: 3306,
      user: 'extract_user',
      password: 'HWtv5nWDA7mcm2N',
      db: 'bd_sistema_extract',
    );

    try {
      _connection = await MySqlConnection.connect(settings);
      print('Conexão com o banco de dados estabelecida com sucesso!');
    } catch (e) {
      print('Erro ao estabelecer conexão com o banco de dados: $e');
    }
  }

  Future<bool> insertUser(User user) async {
  await _connect(); // Garante que a conexão está estabelecida
    try {
      var sql = 'SELECT COUNT(*) as count FROM users WHERE nickname = ?';
      Results results = await _connection.query(sql, [user.nickname]);
      var count = results.first.fields['count'] as int;

      if (count > 0) {
        return false; // Retorna false se o nickname já existir
      }

      await _connection.query(
        'INSERT INTO users (pat, nickname) VALUES (?, ?)',
        [user.pat, user.nickname],
      );
      return true; // Retorna true se o usuário for inserido com sucesso
    } catch (e) {
      return false; // Retorna false se ocorrer um erro
    }
  }




  Future<List<User>> getAllUsers() async {
    await _connect(); // Garante que a conexão está estabelecida
    try {
      Results results = await _connection.query('SELECT pat, nickname FROM users');
      List<User> users = results.map((r) => User(pat: r[0] as int, nickname: r[1] as String)).toList();
      return users;
    } catch (e) {
      print('Erro ao recuperar usuários: $e');
      return []; // Retorna uma lista vazia em caso de erro
    }
  }


  Future<void> closeConnection() async {
    await _connection.close();
  }
}
