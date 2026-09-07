import 'package:sembast_web/sembast_web.dart';

Future<Database> openMediaDatabase() =>
    databaseFactoryWeb.openDatabase('forge_media_v1');
