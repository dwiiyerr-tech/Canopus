import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:canopus/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CanopusApp());
    expect(find.text('Canopus'), findsWidgets);
  });
}
