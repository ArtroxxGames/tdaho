import 'package:flutter/material.dart';
import 'package:myapp/models/subscription.dart';

class SubscriptionProvider with ChangeNotifier {
  final List<Subscription> _subscriptions = [
    Subscription(
      id: '1',
      name: 'Netflix',
      amount: 15.99,
      billingCycle: BillingCycle.mensual,
      nextPaymentDate: DateTime.now().add(const Duration(days: 10)),
    ),
    Subscription(
      id: '2',
      name: 'Spotify',
      amount: 9.99,
      billingCycle: BillingCycle.mensual,
      nextPaymentDate: DateTime.now().add(const Duration(days: 5)),
    ),
    Subscription(
      id: '3',
      name: 'Amazon Prime',
      amount: 139,
      billingCycle: BillingCycle.anual,
      nextPaymentDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  List<Subscription> get subscriptions => _subscriptions;

  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    _sortSubscriptions();
    notifyListeners();
  }

  void updateSubscription(Subscription oldSubscription, Subscription newSubscription) {
    final index = _subscriptions.indexOf(oldSubscription);
    if (index != -1) {
      _subscriptions[index] = newSubscription;
      _sortSubscriptions();
      notifyListeners();
    }
  }

  void deleteSubscription(Subscription subscription) {
    _subscriptions.remove(subscription);
    notifyListeners();
  }

  void _sortSubscriptions() {
    _subscriptions.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
  }

  void deleteAll() {
    _subscriptions.clear();
    notifyListeners();
  }
}
