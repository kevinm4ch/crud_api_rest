import 'dart:convert';

import 'package:crud_api_rest/album_model.dart';
import 'package:crud_api_rest/data/service/album_service.dart';

class AlbumRepository {
  final AlbumService albumService;

  AlbumRepository({required this.albumService});

  Future<List<Album>> fetchAlbums() async {
    final response = await albumService.get();

    final List<dynamic> albums = json.decode(response.body);
    return albums.map((json) => Album.fromJson(json)).toList();
  }
}
