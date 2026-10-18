import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/components/nexus_bottom_nav_bar.dart';
import 'core/components/nexus_top_app_bar.dart';
import 'core/services/firebase_auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_sheet.dart';
import 'features/energy/controllers/energy_controller.dart';
import 'features/energy/models/energy_models.dart';
import 'features/energy/presentation/energy_analytics_screen.dart';
import 'features/overview/controllers/overview_controller.dart';
import 'features/overview/models/overview_models.dart';
import 'features/overview/presentation/overview_screen.dart';
import 'features/rooms/controllers/rooms_controller.dart';
import 'features/rooms/models/room_models.dart';
import 'features/rooms/presentation/rooms_zones_screen.dart';
import 'features/routines/controllers/routines_controller.dart';
import 'features/routines/models/routine_models.dart';
import 'features/routines/presentation/automations_routines_screen.dart';
import 'features/settings/controllers/settings_controller.dart';
import 'features/settings/models/settings_models.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Firebase initialization notice: $e');
  }

  runApp(const NexusHabitatApp());
}

class NexusHabitatApp extends StatelessWidget {
  const NexusHabitatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Habitat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HabitatShell(),
    );
  }
}

class HabitatShell extends StatefulWidget {
  const HabitatShell({super.key});

  @override
  State<HabitatShell> createState() => _HabitatShellState();
}

class _HabitatShellState extends State<HabitatShell> {
  late final OverviewController _overviewController;
  late final RoomsController _roomsController;
  late final EnergyController _energyController;
  late final RoutinesController _routinesController;
  late final SettingsController _settingsController;
  late final FirebaseAuthService _authService;
  late final FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _authService = FirebaseAuthService();
    _firestoreService = FirestoreService();
    _firestoreService.seedInitialDataIfEmpty();

    _overviewController = OverviewController(_firestoreService);
    _roomsController = RoomsController(firestoreService: _firestoreService);
    _energyController = EnergyController(_firestoreService);
    _routinesController = RoutinesController(firestoreService: _firestoreService);
    _settingsController = SettingsController(_firestoreService);
  }

  @override
  void dispose() {
    _overviewController.dispose();
    _roomsController.dispose();
    _energyController.dispose();
    _routinesController.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<OverviewState>(
      valueListenable: _overviewController,
      builder: (context, state, _) {
        return Scaffold(
          extendBody: true,
          appBar: NexusTopAppBar(
            habitatName: state.telemetry.habitatName,
            statusText: state.telemetry.overallStatus,
            temperatureText: "${state.telemetry.overallTemp.toInt()}°C",
            powerDemandText: "${state.telemetry.powerDemandKw} kW",
            hasUnreadNotification: state.hasUnreadNotifications,
            onNotificationClick: () => _overviewController.onAction(const ToggleNotificationsAction()),
            onAvatarClick: () => AuthSheet.show(context, _authService),
          ),
          bottomNavigationBar: NexusBottomNavBar(
            currentDestination: state.currentNavDestination,
            onDestinationSelected: (destination) {
              _overviewController.onAction(SelectNavigationAction(destination));
            },
          ),
          body: switch (state.currentNavDestination) {
            NavDestination.rooms => ValueListenableBuilder<RoomsUiState>(
                valueListenable: _roomsController,
                builder: (context, roomsState, _) {
                  return RoomsZonesScreen(
                    state: roomsState,
                    onAction: _roomsController.onAction,
                  );
                },
              ),
            NavDestination.routines => ValueListenableBuilder<RoutinesUiState>(
                valueListenable: _routinesController,
                builder: (context, routinesState, _) {
                  return AutomationsRoutinesScreen(
                    state: routinesState,
                    onAction: _routinesController.onAction,
                  );
                },
              ),
            NavDestination.energy => ValueListenableBuilder<EnergyUiState>(
                valueListenable: _energyController,
                builder: (context, energyState, _) {
                  return EnergyAnalyticsScreen(
                    state: energyState,
                    onAction: _energyController.onAction,
                  );
                },
              ),
            NavDestination.settings => ValueListenableBuilder<SettingsUiState>(
                valueListenable: _settingsController,
                builder: (context, settingsState, _) {
                  return SettingsScreen(
                    state: settingsState,
                    onAction: _settingsController.onAction,
                  );
                },
              ),
            _ => OverviewScreen(
                state: state,
                onAction: _overviewController.onAction,
              ),
          },
        );
      },
    );
  }
}
