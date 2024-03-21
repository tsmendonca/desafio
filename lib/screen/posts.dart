import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<dynamic> _posts = [];
  int _currentPage = 1;
  int _postsPerPage = 3; // Defina quantos posts deseja por página

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=$_currentPage&_limit=$_postsPerPage'));
      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body) as List<dynamic>;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _fetchPosts();
      });
    }
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
      _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts Recentes'),
      ),
      body: _posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_posts[index]['title'] ?? ''),
                  subtitle: Text(_posts[index]['body'] ?? ''),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _previousPage,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _nextPage,
            ),
          ],
        ),
      ),
    );
  }
}
