import 'package:flutter/widgets.dart';

import 'app.dart';
import 'http/api_service.dart';

void main() {
  ApiService.init();
  runApp(App());
}
