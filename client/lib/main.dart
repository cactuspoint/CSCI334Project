import 'dart:ui';
import 'package:client/utils/helpers/alerts-helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

import 'package:client/screens/welcome.dart';
import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:client/utils/helpers/notification-helper.dart';

void main() {
  AlertsHelper.setup();
  NotificationHelper.setup();
  runApp(GraphqlApp());
}

class GraphqlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use host IP if building for android sub device
    var graphQLURL = 'http://127.0.0.1:5000/graphql';
    // Create HttpLink from decided address above
    final HttpLink link = HttpLink(
      graphQLURL,
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationHelper.openListeningStream();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: WelcomePage(),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
