import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:myapp/models/expense.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/widgets/add_expense_form.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  void _showExpenseForm(BuildContext context, {Expense? expense}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddExpenseForm(
            expense: expense,
            onSave: (newExpense) {
              final provider = Provider.of<ExpenseProvider>(context, listen: false);
              if (expense == null) {
                provider.addExpense(newExpense);
              } else {
                provider.updateExpense(expense, newExpense);
              }
            },
          ),
        );
      },
    );
  }

  void _changeMonth(int increment) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + increment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final monthlyExpenses = expenseProvider.getExpensesForMonth(_selectedMonth);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expenses,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildMonthSelector(context),
            const SizedBox(height: 24),
            _buildChart(expenseProvider.groupedExpenses),
            const SizedBox(height: 24),
            Expanded(
              child: monthlyExpenses.isEmpty
                  ? Center(
                      child: Text(
                        'No hay gastos para este mes.',
                        style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                      ),
                    )
                  : _buildExpenseList(monthlyExpenses),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Gasto",
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => _changeMonth(-1)),
        Text(
          DateFormat.yMMMM('es').format(_selectedMonth),
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => _changeMonth(1)),
      ],
    );
  }

  Widget _buildChart(Map<ExpenseCategory, double> groupedExpenses) {
    if (groupedExpenses.isEmpty) {
      return const SizedBox(height: 150, child: Center(child: Text("No hay datos para el gráfico")));
    }

    final List<PieChartSectionData> sections = groupedExpenses.entries.map((entry) {
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '${(entry.value / groupedExpenses.values.reduce((a, b) => a + b) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 150,
      child: PieChart(
        PieChartData(
          sections: sections,
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildExpenseList(List<Expense> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(expense.category),
              child: _getCategoryIcon(expense.category),
            ),
            title: Text(expense.description, style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
            subtitle: Text(DateFormat.yMMMd().format(expense.date)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  NumberFormat.currency(symbol: '€').format(expense.amount),
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.white70),
                  onPressed: () => _showExpenseForm(context, expense: expense),
                ),
                 IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.white70),
                  onPressed: () {
                    Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense);
                  }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.Supermercado:
        return Colors.green.shade400;
      case ExpenseCategory.Transporte:
        return Colors.blue.shade400;
      case ExpenseCategory.Ocio:
        return Colors.orange.shade400;
      case ExpenseCategory.Hogar:
        return Colors.purple.shade400;
      case ExpenseCategory.Salud:
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.Supermercado:
        return Icons.shopping_cart;
      case ExpenseCategory.Transporte:
        return Icons.directions_bus;
      case ExpenseCategory.Ocio:
        return Icons.sports_esports;
      case ExpenseCategory.Hogar:
        return Icons.home;
      case ExpenseCategory.Salud:
        return Icons.favorite;
      default:
        return Icons.receipt;
    }
  }
}
