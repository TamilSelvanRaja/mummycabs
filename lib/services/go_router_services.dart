import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/ui/admin/admin_dashboard.dart';
import 'package:mummy_cabs/ui/admin/car_detail.dart';
import 'package:mummy_cabs/ui/admin/compant_triplist.dart';
import 'package:mummy_cabs/ui/admin/company_add_edit.dart';
import 'package:mummy_cabs/ui/admin/customers_list.dart';
import 'package:mummy_cabs/ui/admin/driver_detail.dart';
import 'package:mummy_cabs/ui/admin/driver_list.dart';
import 'package:mummy_cabs/ui/admin/pending_list.dart';
import 'package:mummy_cabs/ui/admin/start_trip.dart';
import 'package:mummy_cabs/ui/admin/trip_list.dart';
import 'package:mummy_cabs/ui/auth/password_screen.dart';
import 'package:mummy_cabs/ui/auth/signin_screen.dart';
import 'package:mummy_cabs/ui/auth/signup_screen.dart';
import 'package:mummy_cabs/ui/auth/splash_screen.dart';
import 'package:mummy_cabs/ui/driver/dashboard.dart';
import 'package:mummy_cabs/ui/driver/satement.dart';
import 'package:mummy_cabs/ui/driver/transaction_pending.dart';
import 'package:mummy_cabs/ui/driver/transaction_status.dart';

class Routes {
  static String initial = '/';
  static String login = 'login';
  static String signup = 'signup';
  static String password = 'password';

  static String adminDashboard = 'adminDashboard';
  static String starttrip = 'starttrip';
  static String cardetails = 'cardetails';
  static String driverdetails = 'driverdetails';
  static String driverlist = 'driverlist';

  static String triplist = 'triplist';
  static String pendingtriplist = 'pendingtriplist';
  static String cartList = 'cartList';

  static String customerList = 'customerList';
  static String companyTripList = 'companyTripList';
  static String companyaddEditTrip = 'companyaddEditTrip';

  static String driverDashboard = 'driverDashboard';
  static String driverTransaction = 'driverTransaction';
  static String driverOldTransaction = 'driverOldTransaction';
  static String driverStatement = 'driverStatement';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    redirect: (context, state) async {
      final loggedIn = await PreferenceService().getString("mobile") != "" && await PreferenceService().getString("password") != "";

      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) {
        return Routes.login;
      }

      if (loggedIn && loggingIn) {
        return Routes.adminDashboard;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: Routes.initial,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
        routes: <RouteBase>[
          GoRoute(
              path: Routes.login,
              builder: (BuildContext context, GoRouterState state) {
                return const LoginScreen();
              }),
          GoRoute(
            path: Routes.signup,
            builder: (BuildContext context, GoRouterState state) {
              return const SignupScreen();
            },
          ),
          GoRoute(
            path: Routes.password,
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordScreen();
            },
          ),
          GoRoute(
            path: Routes.adminDashboard,
            builder: (BuildContext context, GoRouterState state) {
              return const AdminDashboard();
            },
          ),
          GoRoute(
            path: Routes.starttrip,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra as Map<String, dynamic>;
              return StartTripScreen(
                isedit: data['isedit'],
                initdata: data['initdata'],
              );
            },
          ),
          GoRoute(
            path: Routes.cardetails,
            builder: (BuildContext context, GoRouterState state) {
              return const CarDetailsScreen();
            },
          ),
          GoRoute(
            path: Routes.driverlist,
            builder: (BuildContext context, GoRouterState state) {
              return const DriverListScreen();
            },
          ),
          GoRoute(
            path: Routes.driverdetails,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra as Map<String, dynamic>;
              return DriverDetailsScreen(
                initdata: data['initdata'],
              );
            },
          ),
          GoRoute(
            path: Routes.triplist,
            builder: (BuildContext context, GoRouterState state) {
              return const TripListPage();
            },
          ),
          GoRoute(
            path: Routes.pendingtriplist,
            builder: (BuildContext context, GoRouterState state) {
              return const PendingListPage();
            },
          ),
          GoRoute(
            path: Routes.driverDashboard,
            builder: (BuildContext context, GoRouterState state) {
              return const DriverDashboard();
            },
          ),
          GoRoute(
            path: Routes.driverTransaction,
            builder: (BuildContext context, GoRouterState state) {
              return const DriverTransactionScreen();
            },
          ),
          GoRoute(
            path: Routes.customerList,
            builder: (BuildContext context, GoRouterState state) {
              return const CustomerDetails();
            },
          ),
          GoRoute(
            path: Routes.companyTripList,
            builder: (BuildContext context, GoRouterState state) {
              return const CompantTripList();
            },
          ),
          GoRoute(
            path: Routes.companyaddEditTrip,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.extra as Map<String, dynamic>;
              return CompantTripScreen(
                isedit: data['isedit'],
                initdata: data['initdata'],
              );
            },
          ),
          GoRoute(
            path: Routes.driverOldTransaction,
            builder: (BuildContext context, GoRouterState state) {
              return const PendingTransactionScreen();
            },
          ),
          GoRoute(
            path: Routes.driverStatement,
            builder: (BuildContext context, GoRouterState state) {
              return const StatementScreen();
            },
          ),
        ],
      ),
    ],
  );
}
