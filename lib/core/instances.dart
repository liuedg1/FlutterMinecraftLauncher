import 'package:logger/logger.dart';

class Instances {
  Instances._();

  static final Logger log = Logger(
    printer: PrettyPrinter(colors: true, printTime: true, methodCount: 0),
  );
}
