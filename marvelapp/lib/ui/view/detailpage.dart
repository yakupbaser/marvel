import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/app/locator.dart';
import 'package:marvelapp/datamodel/marvel.dart';
import 'package:marvelapp/service/repository_manager.dart';

class DetailPage extends StatefulWidget {
  final MarvelCharacter character;
  const DetailPage({Key? key, required this.character}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final repositoryManager = locator<RepositoryManager>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        await repositoryManager.getComics(widget.character.id);
      } catch (e) {
        debugPrint(e.toString());
      }
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            Text(widget.character.name),
            SizedBox(
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.character.thumbnail.path +
                    '.' +
                    widget.character.thumbnail.extension,
              ),
            ),
            Text(widget.character.description),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: ListView(
                children: [
                  ...repositoryManager.comics
                      .map((e) => Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Text(e.title),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(e.dates[0].date)
                              ],
                            ),
                          ))
                      .toList()
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
