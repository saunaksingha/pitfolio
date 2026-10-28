import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'core/theme/app_theme.dart';
import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/unit_preferences_screen.dart';
import 'screens/main_navigation_screen.dart';

class PitfolioApp extends StatelessWidget {
  const PitfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Pitfolio',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),

            '/preferences': (context) => UnitPreferencesScreen(),

            '/home': (context) => const MainNavigationScreen(),
          },
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// import 'core/theme/app_theme.dart';
// import 'screens/onboarding/splash_screen.dart';
// import 'screens/onboarding/unit_preferences_screen.dart';

// class PitfolioApp extends StatelessWidget {
//   const PitfolioApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilPlusInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           title: 'Pitfolio',
//           debugShowCheckedModeBanner: false,
//           theme: AppTheme.lightTheme,
//           themeMode: ThemeMode.light,
//           initialRoute: '/',
//           routes: {
//             '/': (context) => const SplashScreen(),
//             '/preferences': (context) => UnitPreferencesScreen(
//               onContinue: (preferences) async {
//                 // Temporary callback until the onboarding
//                 // controller and Add Vehicle screen exist.
//                 debugPrint('Currency: ${preferences.currency}');
//                 debugPrint('Distance: ${preferences.distanceUnit}');
//                 debugPrint(
//                   'Fuel capacity: '
//                   '${preferences.fuelCapacityUnit}',
//                 );
//               },
//             ),
//           },
//         );
//       },
//     );
//   }
// }
