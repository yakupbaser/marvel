import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/app/locator.dart';
import 'package:marvelapp/service/repository_manager.dart';
import 'package:marvelapp/ui/view/detailpage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repositoryManager = locator<RepositoryManager>();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        await repositoryManager.getCharacters();
      } catch (e) {
        debugPrint(e.toString());
      }
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      await repositoryManager.getCharacters();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) setState(() {});
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            header: const WaterDropHeader(),
            controller: refreshController,
            onLoading: _onLoading,
            child: ListView(
              children: repositoryManager.characters
                  .map((e) => Container(
                        height: 80,
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(e.name),
                            trailing: CachedNetworkImage(
                              imageUrl: e.thumbnail.path +
                                  '.' +
                                  e.thumbnail.extension,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(character: e)));
                            },
                          ),
                        ),
                      ))
                  .toList(),
            )),
      ),
    );
  }
}
