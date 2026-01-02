import 'package:flutter/widgets.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
