import 'package:backend/backend.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final example = Example();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(example.exampleTrue, isTrue);
    });
  });
}
