import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class NoSwipeMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoSwipeMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
    builder: builder,
    settings: settings,
  );

  @override
  bool get popGestureEnabled => false;
}

class AppNavigator {
  /// PUSH
  static Future<T?> push<T extends Object?>(
      BuildContext context,
      Widget destination, {
        StateStreamableSource<Object?>? bloc,
        List<SingleChildWidget>? multiBlocProviders,

        /// Disable iOS swipe back gesture
        bool disableSwipeBack = false,
      }) {
    return Navigator.push(
      context,
      _buildRoute(
        destination,
        bloc: bloc,
        multiBlocProviders: multiBlocProviders,
        disableSwipeBack: disableSwipeBack,
      ),
    );
  }

  /// PUSH REPLACEMENT
  static Future<T?> pushReplacement<
  T extends Object?,
  TO extends Object?>(
      BuildContext context,
      Widget destination, {
        StateStreamableSource<Object?>? bloc,
        List<SingleChildWidget>? multiBlocProviders,

        /// Disable iOS swipe back gesture
        bool disableSwipeBack = false,
      }) {
    return Navigator.pushReplacement(
      context,
      _buildRoute(
        destination,
        bloc: bloc,
        multiBlocProviders: multiBlocProviders,
        disableSwipeBack: disableSwipeBack,
      ),
    );
  }

  /// PUSH AND REMOVE UNTIL
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      BuildContext context,
      Widget destination, {
        StateStreamableSource<Object?>? bloc,
        List<SingleChildWidget>? multiBlocProviders,

        /// Disable iOS swipe back gesture
        bool disableSwipeBack = false,
      }) {
    return Navigator.pushAndRemoveUntil(
      context,
      _buildRoute(
        destination,
        bloc: bloc,
        multiBlocProviders: multiBlocProviders,
        disableSwipeBack: disableSwipeBack,
      ),
          (route) => false,
    );
  }

  /// POP
  static void pop<T extends Object?>(
      BuildContext context, [
        T? result,
      ]) {
    Navigator.pop(context, result);
  }

  /// COMMON ROUTE BUILDER
  static Route<T> _buildRoute<T extends Object?>(
      Widget destination, {
        StateStreamableSource<Object?>? bloc,
        List<SingleChildWidget>? multiBlocProviders,
        bool disableSwipeBack = false,
      }) {
    final page = _buildPage(
      destination,
      bloc,
      multiBlocProviders,
    );

    if (disableSwipeBack) {
      return NoSwipeMaterialPageRoute<T>(
        builder: (_) => page,
      );
    }

    return MaterialPageRoute<T>(
      builder: (_) => page,
    );
  }

  /// COMMON PAGE BUILDER
  static Widget _buildPage(
      Widget destination,
      StateStreamableSource<Object?>? bloc,
      List<SingleChildWidget>? multiBlocProviders,
      ) {
    if (bloc != null) {
      return BlocProvider.value(
        value: bloc,
        child: destination,
      );
    }

    if (multiBlocProviders != null) {
      return MultiBlocProvider(
        providers: multiBlocProviders,
        child: destination,
      );
    }

    return destination;
  }
}


// // 1. Simple Navigation
// AppNavigator.push(
// context,
// HomeScreen(),
// );
//
// // 2. Disable iOS Left Swipe Gesture
// AppNavigator.push(
// context,
// HomeScreen(),
// disableSwipeBack: true,
// );
//
// // 3. Push Replacement
// AppNavigator.pushReplacement(
// context,
// DashboardScreen(),
// );
//
// // 4. Push Replacement + Disable Swipe
// AppNavigator.pushReplacement(
// context,
// DashboardScreen(),
// disableSwipeBack: true,
// );
//
// // 5. Push With Cubit / Bloc
// AppNavigator.push(
// context,
// HomeScreen(),
// bloc: context.read<HomeCubit>(),
// );
//
// // 6. Push With Multiple Blocs
// AppNavigator.push(
// context,
// HomeScreen(),
// multiBlocProviders: [
// BlocProvider.value(
// value: context.read<HomeCubit>(),
// ),
// BlocProvider.value(
// value: context.read<AuthCubit>(),
// ),
// ],
// );
//
// // 7. Remove All Previous Screens (Logout Flow)
// AppNavigator.pushAndRemoveUntil(
// context,
// LoginScreen(),
// disableSwipeBack: true,
// );
//
// // 8. Pop Screen
// AppNavigator.pop(context);
//
// // 9. Pop With Result
// AppNavigator.pop(context, true);
//
// // 10. Receive Result From Next Screen
// final result = await AppNavigator.push(
// context,
// DetailsScreen(),
// );
//
// if (result == true) {
// print("Success");
// }