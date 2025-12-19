import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdah_organizer/models/subscription.dart';
import 'package:tdah_organizer/providers/subscription_provider.dart';
import 'package:tdah_organizer/widgets/add_subscription_form.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  void _showAddSubscriptionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddSubscriptionForm(onAdd: (name, amount, nextBilling) {
            final newSubscription = Subscription(name: name, amount: amount, nextBilling: nextBilling);
            Provider.of<SubscriptionProvider>(context, listen: false).addSubscription(newSubscription);
          }),
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
        onPressed: () => _showAddSubscriptionForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Suscripción",
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, Subscription subscription) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscription.name,
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              "\$${subscription.amount.toStringAsFixed(2)} / mes",
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue.shade300),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  "Próximo cobro: ${subscription.nextBilling.day}/${subscription.nextBilling.month}/${subscription.nextBilling.year}",
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
