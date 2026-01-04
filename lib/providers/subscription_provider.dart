import 'package:flutter/material.dart';
import 'package:myapp/models/subscription.dart';
import 'package:myapp/services/storage_service.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Subscription> _subscriptions = [];

  SubscriptionProvider() {
    _loadSubscriptions();
  }

  List<Subscription> get subscriptions => _subscriptions;

  void _loadSubscriptions() {
    _subscriptions = StorageService.loadList<Subscription>(
      StorageService.subscriptionsBox,
      (json) => Subscription.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_subscriptions.isEmpty) {
      _subscriptions = [
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
      _saveSubscriptions();
    } else {
      _sortSubscriptions();
    }
  }

  Future<void> _saveSubscriptions() async {
    await StorageService.saveList(StorageService.subscriptionsBox, _subscriptions);
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    _subscriptions.add(subscription);
    _sortSubscriptions();
    await _saveSubscriptions();
  }

  Future<void> updateSubscription(Subscription oldSubscription, Subscription newSubscription) async {
    final index = _subscriptions.indexOf(oldSubscription);
    if (index != -1) {
      _subscriptions[index] = newSubscription;
      _sortSubscriptions();
      await _saveSubscriptions();
    }
  }

  Future<void> deleteSubscription(Subscription subscription) async {
    _subscriptions.remove(subscription);
    await _saveSubscriptions();
  }

  void _sortSubscriptions() {
    _subscriptions.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
  }

  Future<void> deleteAll() async {
    _subscriptions.clear();
    await _saveSubscriptions();
  }
}
