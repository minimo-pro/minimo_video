import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

@RoutePage()
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(S.of(context).todo)));
  }
}
