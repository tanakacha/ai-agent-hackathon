import 'package:riverpod_annotation/riverpod_annotation.dart';

part '_generated/map_input_notifier.g.dart';

@riverpod
class MapInputNotifier extends _$MapInputNotifier {
  @override
  String build() {
    return 'map-5678';
  }

  void updateMapId(String mapId) {
    state = mapId;
  }
}
