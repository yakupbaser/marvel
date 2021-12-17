import 'package:flutter/material.dart';
import 'package:marvelapp/app/locator.dart';
import 'package:marvelapp/ui/view/homepage.dart';

import 'service/repository_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  /*final repositoryManager = locator<RepositoryManager>();
  try {
    await repositoryManager.getCharacters();
  } catch (e) {
    debugPrint(e.toString());
  }*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
