import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/subscription.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/utils/currency_formatter.dart';
import 'package:myapp/widgets/add_subscription_form.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  void _showSubscriptionForm(BuildContext context, {Subscription? subscription}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddSubscriptionForm(
            subscription: subscription,
            onSave: (newSubscription) async {
              final provider = Provider.of<SubscriptionProvider>(context, listen: false);
              if (subscription == null) {
                await provider.addSubscription(newSubscription);
              } else {
                await provider.updateSubscription(subscription, newSubscription);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.subscriptions,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<SubscriptionProvider>(
                builder: (context, subscriptionProvider, child) {
                   if (subscriptionProvider.subscriptions.isEmpty) {
                    return Center(
                      child: Text(
                        'No tienes suscripciones registradas.',
                        style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: subscriptionProvider.subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = subscriptionProvider.subscriptions[index];
                      return _buildSubscriptionCard(context, subscription);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubscriptionForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Suscripción",
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, Subscription subscription) {
    final settings = Provider.of<SettingsProvider>(context);
    final formattedAmount = CurrencyFormatter.format(subscription.amount, settings: settings);
    final formattedDate = DateFormat.yMMMd().format(subscription.nextPaymentDate);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          child: Icon(Icons.autorenew),
        ),
        title: Text(subscription.name, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '$formattedAmount / ${subscription.billingCycle.name} \nPróximo pago: $formattedDate',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _showSubscriptionForm(context, subscription: subscription),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white70),
              onPressed: () async {
                await Provider.of<SubscriptionProvider>(context, listen: false)
                    .deleteSubscription(subscription);
              },
            ),
          ],
        ),
      ),
    );
  }
}
