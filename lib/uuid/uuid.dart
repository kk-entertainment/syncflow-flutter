import 'package:uuid/uuid.dart';

const uuid = Uuid();

String generateUniqueID() {
  return uuid.v4();
}
