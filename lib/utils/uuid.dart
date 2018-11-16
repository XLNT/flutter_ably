import 'package:uuid/uuid.dart';

final myUuid = Uuid();

String uuid() => myUuid.v4();
