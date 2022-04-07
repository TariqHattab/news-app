import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations tr(BuildContext context) => AppLocalizations.of(context)!;

printData(Object? m) {
  if (kDebugMode) {
    print(m);
  }
}
