import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _exchangeRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _exchangeRateController.text = settings.exchangeRateUsdPyg.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildCurrencySection(context),
            const SizedBox(height: 24),
            _buildExchangeRateSection(context),
            const SizedBox(height: 24),
            _buildStatisticsSection(context),
            const SizedBox(height: 24),
            _buildDangerZone(context),
            const SizedBox(height: 24),
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moneda Principal',
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Column(
                  children: Currency.values.map((currency) {
                    return RadioListTile<Currency>(
                      title: Text('${currency.symbol} ${currency.name} (${currency.code})'),
                      value: currency,
                      groupValue: settings.currency,
                      onChanged: (value) {
                        if (value != null) {
                          settings.setCurrency(value);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRateSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de Cambio USD/PYG',
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valor actual: 1 USD = ${settings.exchangeRateUsdPyg.toStringAsFixed(0)} PYG',
                      style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _exchangeRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nuevo tipo de cambio (PYG)',
                        hintText: 'Ej: 7500',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: AppColors.bgCard,
                      ),
                      style: GoogleFonts.roboto(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final value = double.tryParse(_exchangeRateController.text);
                        if (value != null && value > 0) {
                          settings.setExchangeRateUsdPyg(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tipo de cambio actualizado: 1 USD = ${value.toStringAsFixed(0)} PYG'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor ingresa un valor válido mayor a 0'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Guardar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas de Datos',
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer2<DebtProvider, SubscriptionProvider>(
              builder: (context, debtProvider, subscriptionProvider, child) {
                final expenseProvider = Provider.of<ExpenseProvider>(context);
                final taskProvider = Provider.of<TaskProvider>(context);
                final noteProvider = Provider.of<NoteProvider>(context);

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: [
                    _buildStatCard('Deudas', debtProvider.debts.length.toString(), Icons.credit_card),
                    _buildStatCard('Suscripciones', subscriptionProvider.subscriptions.length.toString(), Icons.subscriptions),
                    _buildStatCard('Gastos', expenseProvider.expenses.length.toString(), Icons.shopping_cart),
                    _buildStatCard('Tareas', taskProvider.tasks.length.toString(), Icons.check_circle),
                    _buildStatCard('Notas', noteProvider.notes.length.toString(), Icons.note),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 1,
      color: AppColors.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.red.shade900.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade400),
                const SizedBox(width: 8),
                Text(
                  'Zona de Peligro',
                  style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red.shade400),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Esta acción eliminará todos los datos de la aplicación. Esta acción no se puede deshacer.',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Eliminar Todos los Datos', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Estás seguro?', style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
        content: Text(
          'Esta acción eliminará TODOS los datos: deudas, suscripciones, gastos, tareas y notas. Esta acción NO se puede deshacer.',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.roboto()),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteAllData(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar Todo', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _deleteAllData(BuildContext context) {
    Provider.of<DebtProvider>(context, listen: false).deleteAll();
    Provider.of<SubscriptionProvider>(context, listen: false).deleteAll();
    Provider.of<ExpenseProvider>(context, listen: false).deleteAll();
    Provider.of<TaskProvider>(context, listen: false).deleteAll();
    Provider.of<NoteProvider>(context, listen: false).deleteAll();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Todos los datos han sido eliminados', style: GoogleFonts.roboto()),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acerca de',
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'TDAH Organizer',
              style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Aplicación diseñada para ayudar a personas con TDAH a organizar sus finanzas y productividad.',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'Versión: 1.0.0',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(height: 8),
            Text(
              'Hecho con 💜 para mentes brillantes',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white54, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
