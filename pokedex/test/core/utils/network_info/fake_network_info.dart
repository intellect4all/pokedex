import 'package:pokedex/core/utils/network_info/network_info.dart';

class FakeNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected => throw UnimplementedError();
}
