import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/credit_card.dart';
import 'package:myapp/providers/credit_card_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/utils/currency_formatter.dart';
import 'package:myapp/widgets/add_credit_card_form.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + increment,
      );
    });
  }

  void _showCreditCardForm(BuildContext context, {CreditCard? creditCard}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddCreditCardForm(
            creditCard: creditCard,
            onSave: (newCard) {
              final provider = Provider.of<CreditCardProvider>(
                context,
                listen: false,
              );
              if (creditCard == null) {
                provider.addCreditCard(newCard);
              } else {
                provider.updateCreditCard(creditCard, newCard);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tarjetas de Crédito',
                  style: GoogleFonts.oswald(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildMonthSelector(),
              ],
            ),
            const SizedBox(height: 24),
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<CreditCardProvider>(
                builder: (context, creditCardProvider, child) {
                  final activeCards = creditCardProvider.creditCards;
                  if (activeCards.isEmpty) {
                    return Center(
                      child: Text(
                        'No tienes tarjetas registradas.',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: activeCards.length,
                    itemBuilder: (context, index) {
                      return _buildCreditCardCard(context, activeCards[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreditCardForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Tarjeta",
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          DateFormat.yMMMM('es').format(_selectedMonth),
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    final creditCardProvider = Provider.of<CreditCardProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    double totalToPay = 0.0;
    double totalAvailable = 0.0;
    double totalLimit = 0.0;

    for (var card in creditCardProvider.creditCards) {
      final toPay = creditCardProvider.getTotalToPay(
        card,
        _selectedMonth,
        expenseProvider,
      );
      totalToPay += toPay;
      final available = creditCardProvider.getAvailable(
        card,
        _selectedMonth,
        expenseProvider,
      );
      if (available != null) {
        totalAvailable += available;
      }
      if (card.creditLimit != null) {
        totalLimit += card.creditLimit!;
      }
    }

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total a Pagar',
            totalToPay,
            Colors.red.shade400,
            settings,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Disponible',
            totalAvailable,
            Colors.green.shade400,
            settings,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Límite Total',
            totalLimit,
            Colors.blue.shade400,
            settings,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color,
    SettingsProvider settings,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(amount, settings: settings),
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardCard(BuildContext context, CreditCard card) {
    final creditCardProvider = Provider.of<CreditCardProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final totalToPay = creditCardProvider.getTotalToPay(
      card,
      _selectedMonth,
      expenseProvider,
    );
    final available = creditCardProvider.getAvailable(
      card,
      _selectedMonth,
      expenseProvider,
    );
    final usagePercentage = creditCardProvider.getUsagePercentage(
      card,
      _selectedMonth,
      expenseProvider,
    );
    final expenses = creditCardProvider.getExpensesForMonth(
      card,
      _selectedMonth,
      expenseProvider,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.credit_card, size: 32),
        title: Text(
          card.displayName,
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.bank != null)
              Text(
                card.bank!,
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
              ),
            Text(
              'Cierre: día ${card.closingDay} | Vence: día ${card.dueDay}',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(card.isActive ? Icons.check_circle : Icons.cancel),
              color: card.isActive ? Colors.green : Colors.grey,
              onPressed: () {
                creditCardProvider.toggleActive(card);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _showCreditCardForm(context, creditCard: card),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Eliminar Tarjeta',
                      style: GoogleFonts.oswald(),
                    ),
                    content: Text(
                      '¿Estás seguro de eliminar esta tarjeta? Los gastos asociados no se eliminarán.',
                      style: GoogleFonts.roboto(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar', style: GoogleFonts.roboto()),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          creditCardProvider.deleteCreditCard(card);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Eliminar', style: GoogleFonts.roboto()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardSummaryRow('Total a pagar', totalToPay, settings),
                if (card.creditLimit != null) ...[
                  const SizedBox(height: 8),
                  _buildCardSummaryRow(
                    'Disponible',
                    available ?? 0.0,
                    settings,
                  ),
                  const SizedBox(height: 8),
                  _buildCardSummaryRow('Límite', card.creditLimit!, settings),
                  const SizedBox(height: 8),
                  _buildUsageBar(usagePercentage),
                ],
                const SizedBox(height: 16),
                Text(
                  'Gastos del mes (${expenses.length})',
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (expenses.isEmpty)
                  Text(
                    'No hay gastos este mes',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  )
                else
                  ...expenses.map(
                    (expense) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              expense.description,
                              style: GoogleFonts.roboto(fontSize: 12),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                              expense.isInstallment
                                  ? expense.installmentAmount
                                  : expense.amount,
                              settings: settings,
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (expense.isInstallment)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '(${expense.currentInstallment}/${expense.numberOfInstallments})',
                                style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSummaryRow(
    String label,
    double amount,
    SettingsProvider settings,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
        ),
        Text(
          CurrencyFormatter.format(amount, settings: settings),
          style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUsageBar(double percentage) {
    Color color = Colors.green;
    if (percentage > 80) {
      color = Colors.red;
    } else if (percentage > 50) {
      color = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Uso',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade800,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
