import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quick_task/index_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '9Kv70hk0X98DRVbbmAC7lIGWSZ6ApbVhiM0fdMWk';
  const keyClientKey = 'LgP7HAzYbVlArWbpZDHjpn2ciJIYUTJ1UWPBsSLk';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const IndexPage());
}
