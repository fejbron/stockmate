import 'package:uuid/uuid.dart';

class InternalCodeGenerator {
  InternalCodeGenerator({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  String generate({required int productId}) {
    final suffix = _uuid.v4().split('-').first.toUpperCase();
    return 'INT-${productId.toString().padLeft(6, '0')}-$suffix';
  }
}
