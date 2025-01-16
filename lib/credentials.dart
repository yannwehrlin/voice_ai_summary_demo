import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials {
  static final String env = dotenv.env['ENV']!;

  static final String cohereApiKey = dotenv.env['COHERE_API_KEY']!;
}
