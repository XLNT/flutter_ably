import 'dart:async';

typedef FutureOr<void> Setup();
typedef FutureOr<void> Teardown();

class Referenceable {
  List<Teardown> _teardowns = [];

  Future<void> addRef({
    setup: Setup,
    teardown: Teardown,
  }) async {
    await setup();
    _teardowns.add(teardown);
  }

  Future<void> dispose() async {
    await Future.wait(_teardowns.map((t) => t()));
  }
}
