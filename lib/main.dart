import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'colors.dart';
import 'generated/l10n.dart';
import 'pages/journal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Log',
      debugShowCheckedModeBanner: true,
      onGenerateTitle: (BuildContext context) => S.of(context).title,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData(primarySwatch: C.primaryColor),
      home: const Journal(),
    );
  }
}
