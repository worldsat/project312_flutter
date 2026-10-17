import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_habitat/main.dart';

void main() {
  testWidgets('Nexus Habitat Overview smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build NexusHabitatApp and pump initial frame
    await tester.pumpWidget(const NexusHabitatApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Nexus Habitat'), findsWidgets);
    expect(find.text('Living Sector Alpha'), findsOneWidget);
    expect(find.text('System Modes'), findsOneWidget);
    expect(find.text('Instant Actions'), findsOneWidget);
    expect(find.text('Energy Vector'), findsOneWidget);
    expect(find.text('Active Devices'), findsOneWidget);
  });

  testWidgets('Nexus Habitat Rooms & Zones navigation and smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusHabitatApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Rooms tab on bottom bar
    await tester.tap(find.text('Rooms'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Rooms & Zones elements
    expect(find.text('Active Habitats'), findsOneWidget);
    expect(find.text('CONFIGURE'), findsOneWidget);
    expect(find.text('All Zones (5)'), findsOneWidget);
    expect(find.text('Living Room'), findsWidgets);
    expect(find.text('Master Cyber Suite'), findsOneWidget);
    expect(find.text('Holodeck Studio'), findsOneWidget);
    expect(find.text('Cyber Kitchen'), findsWidgets);
    expect(find.text('Pair New Zone or Node'), findsOneWidget);
  });

  testWidgets('Nexus Habitat Energy Analytics navigation and interaction test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusHabitatApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Energy tab on bottom bar
    await tester.tap(find.text('Energy'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Energy elements visible in the initial viewport
    expect(find.text('Energy Matrix'), findsOneWidget);
    expect(find.text('Power Flux'), findsOneWidget);
    expect(find.text('TOTAL DEMAND'), findsOneWidget);
    expect(find.text('Solar Inflow'), findsOneWidget);
    expect(find.text('Grid Pull'), findsOneWidget);
    expect(find.text('Consumption Dynamics'), findsOneWidget);
    expect(find.text('Active Appliance Drain'), findsOneWidget);
    expect(find.text('Climate Control System'), findsOneWidget);

    // Scroll down to reveal Nexus Intelligence
    await tester.scrollUntilVisible(
      find.text('Nexus Intelligence'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Nexus Intelligence'), findsOneWidget);

    // Scroll to optimization CTA
    final ctaFinder = find.text('Apply Auto-Power Optimization (Save 0.4 kWh)');
    await tester.scrollUntilVisible(
      ctaFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(ctaFinder, findsOneWidget);

    await tester.tap(ctaFinder);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Optimization Engaged • 0.4 kWh Preserved'), findsWidgets);
  });

  testWidgets('Nexus Habitat Routines navigation and interaction test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusHabitatApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Routines tab on bottom bar
    await tester.tap(find.text('Routines'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Routines screen elements
    expect(find.text('PROTOCOL SYNAPSE'), findsOneWidget);
    expect(find.text('AI Autonomous Engine Active'), findsOneWidget);
    expect(find.text('Triggers Fired'), findsOneWidget);
    expect(find.text('Success Vector'), findsOneWidget);
    expect(find.text('LOGIC ARCHITECT'), findsOneWidget);
    expect(find.text('Construct Automation'), findsOneWidget);
    expect(find.text('Deploy New Routine'), findsOneWidget);
    expect(find.text('Scheduled Sequences'), findsOneWidget);
    expect(find.text('Sunrise Awakening'), findsOneWidget);

    // Test Deploy New Routine CTA
    await tester.tap(find.text('Deploy New Routine'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Routine Logic Architect: New Neural Sequence Template Ready'), findsOneWidget);

    // Test Sort Matrix
    await tester.tap(find.text('Sort Matrix'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Sorted: A-Z'), findsOneWidget);
  });

  testWidgets('Nexus Habitat Settings navigation and interaction test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusHabitatApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Settings tab on bottom bar
    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify initial settings elements
    expect(find.text('Habitat Matrix'), findsOneWidget);
    expect(find.text('NEXUS-ALPHA-77'), findsOneWidget);
    expect(find.text('ONLINE'), findsOneWidget);
    expect(find.text('Hub Health'), findsOneWidget);
    expect(find.text('RF Latency'), findsOneWidget);
    expect(find.text('Total Uptime'), findsOneWidget);
    expect(find.text('MESH & PROTOCOL CONNECTIVITY'), findsOneWidget);
    expect(find.text('Thread Mesh Protocol (6LoWPAN)'), findsOneWidget);

    // Scroll to Grid Security section
    final armLockFinder = find.text('ARM LOCK');
    await tester.scrollUntilVisible(
      armLockFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(armLockFinder, findsOneWidget);

    // Test ARM LOCK emergency toggle
    await tester.tap(armLockFinder);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('DISARM'), findsOneWidget);
  });
}



