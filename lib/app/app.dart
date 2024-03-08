import 'package:flutter/cupertino.dart';
import 'package:syncflow/router/router.dart';
import 'package:syncflow/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      theme: theme,
      routerConfig: router,
    );
  }
}
