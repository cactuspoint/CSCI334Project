import 'dart:ui';
import 'welcome.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'globals.dart' as globals;

void main() {
  runApp(GraphqlApp());
  globals.jwt = "hello";
}

class GraphqlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink link = HttpLink(
      'http://10.0.2.2:5000/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        // store: GraphQLCache(store: HiveStore()),
        cache: GraphQLCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        accentColor: Colors.orangeAccent,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        // visualDensity: VisualDensity(horizontal: 4.0, vertical: 4.0),
        accentColor: Colors.orangeAccent,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
