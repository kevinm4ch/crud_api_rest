import 'dart:convert';

import 'package:crud_api_rest/data/models/album_model.dart';
import 'package:crud_api_rest/data/repository/album_repository.dart';
import 'package:crud_api_rest/data/service/album_service.dart';
import 'package:crud_api_rest/utils/api.dart';
import 'package:flutter/material.dart';

// Future<List<Album>> fetchAlbum() async {
//   final response =
//       await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return List<Album>.from(
//         jsonDecode(response.body).map((x) => Album.fromJson(x)));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: ListResponse(),
        ));
  }
}

class ListResponse extends StatefulWidget {
  const ListResponse({super.key});

  @override
  State<ListResponse> createState() => _ListResponseState();
}

class _ListResponseState extends State<ListResponse> {
  late AlbumService _albumService;
  late AlbumRepository _albumRepository;
  late bool isLoading;
  late List<Album> albums;
  String? errorMessage;

  @override
  void initState() {
    _albumService = AlbumService(baseUrl: Api.baseUrl);
    _albumRepository = AlbumRepository(albumService: _albumService);
    _loadingAlbums();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    }

    if (errorMessage != null) {
      return Text('Erro: $errorMessage');
    }

    return ListView.builder(
      itemCount: albums!.length,
      itemBuilder: (context, index) {
        final album = albums![index];
        return ListTile(
          title: Text(album.title),
        );
      },
    );
  }

  Future<void> _loadingAlbums() async {
    try {
      final fetchedAlbums = await _albumRepository.fetchAlbums();
      setState(() {
        albums = fetchedAlbums;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }
}
