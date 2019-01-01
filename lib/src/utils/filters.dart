import 'package:flutter/services.dart';

import '../packets/packet.dart';

bool Function(MethodCall) methodIs(String method) => //
    (MethodCall call) => call.method == method;

bool Function(Packet) clientIs(String clientId) => //
    (Packet packet) => packet.clientId == clientId;

bool Function(Packet) channelIs(String channelId) => //
    (Packet packet) => packet.channelId == channelId;
