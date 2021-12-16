import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_table/responsive_table.dart';

void main() {
  const MethodChannel channel = MethodChannel('responsive_table');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
  
}
