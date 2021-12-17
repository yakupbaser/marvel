import 'dart:convert';

import 'package:marvelapp/app/constant/constants.dart';
import 'package:marvelapp/app/utilities/utilities.dart';
import 'package:marvelapp/datamodel/marvel.dart';
import 'package:marvelapp/datamodel/comics.dart' as comic;
import 'package:http/http.dart' as http;

class RepositoryManager {
  int limit = 30;
  int offset = 0;
  List<MarvelCharacter> characters = [];
  List<comic.Comic> comics = [];

  buildUrl(String queryUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash =
        generateMd5('$timestamp${Constants.privateKey}${Constants.publicKey}');
    return Constants.baseUrl +
        "$queryUrl?limit=$limit&offset=$offset&apikey=${Constants.publicKey}&hash=$hash&ts=$timestamp";
  }

  buildComicsUrl(String queryUrl) {
    final today = DateTime.now();
    final timestamp = today.millisecondsSinceEpoch;
    final hash =
        generateMd5('$timestamp${Constants.privateKey}${Constants.publicKey}');
    return Constants.baseUrl +
        "$queryUrl?dateRange=2005-01-01,${today.toIso8601String()}&limit=10&apikey=${Constants.publicKey}&hash=$hash&ts=$timestamp";
  }

  Future<void> getCharacters() async {
    final url = buildUrl("/characters");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonDecode = json.decode(response.body);
      final Marvel marvel = Marvel.fromJson(jsonDecode);
      characters.addAll(marvel.data.results);
      offset = offset + 30;
    } else {
      throw Exception("Error status code: ${response.statusCode}");
    }
  }

  Future<void> getComics(int characterId) async {
    final url = buildComicsUrl('/characters/$characterId/comics');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonDecode = json.decode(response.body);
      final comic.Comics comicModel = comic.Comics.fromJson(jsonDecode);
      comics = comicModel.data.results;
    } else {
      throw Exception("Error status code: ${response.statusCode}");
    }
  }
}
