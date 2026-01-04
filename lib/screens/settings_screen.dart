import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/providers/credit_card_provider.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/course_provider.dart';
import 'package:myapp/services/backup_service.dart';
import 'package:myapp/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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
            _buildBackupSection(context),
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

  Widget _buildBackupSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.backup, color: AppColors.accentPrimary),
                const SizedBox(width: 8),
                Text(
                  'Backup y Restauración',
                  style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Exporta todos tus datos a un archivo JSON para hacer una copia de seguridad, o importa datos desde un archivo de respaldo.',
              style: GoogleFonts.roboto(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportData(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar Datos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _importData(context),
                    icon: const Icon(Icons.upload),
                    label: const Text('Importar Datos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final debtProvider = Provider.of<DebtProvider>(context, listen: false);
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      final creditCardProvider = Provider.of<CreditCardProvider>(context, listen: false);
      final overduePaymentProvider = Provider.of<OverduePaymentProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      final filePath = await BackupService.exportData(
        context: context,
        debtProvider: debtProvider,
        subscriptionProvider: subscriptionProvider,
        expenseProvider: expenseProvider,
        creditCardProvider: creditCardProvider,
        overduePaymentProvider: overduePaymentProvider,
        taskProvider: taskProvider,
        noteProvider: noteProvider,
        courseProvider: courseProvider,
        settingsProvider: settingsProvider,
      );

      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading

        if (filePath != null) {
          // Compartir el archivo
          final file = File(filePath);
          if (await file.exists()) {
            await Share.shareXFiles(
              [XFile(filePath)],
              text: 'Backup de TDAH Organizer',
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Datos exportados exitosamente',
                style: GoogleFonts.roboto(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al exportar los datos',
                style: GoogleFonts.roboto(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading si está abierto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.roboto(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context) async {
    try {
      // Mostrar advertencia
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Importar Datos', style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
          content: Text(
            '⚠️ ADVERTENCIA: Esta acción reemplazará todos los datos actuales con los datos del archivo importado.\n\n'
            'Se recomienda hacer un backup antes de importar.\n\n'
            '¿Deseas continuar?',
            style: GoogleFonts.roboto(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar', style: GoogleFonts.roboto()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Continuar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final result = await BackupService.importData(context);

      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading

        if (result != null && result['success'] == true) {
          // Confirmar importación
          final confirmImport = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirmar Importación', style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
              content: Text(
                'El archivo se validó correctamente.\n\n'
                'Versión: ${result['version']}\n'
                'Fecha de exportación: ${result['exportDate'] ?? 'Desconocida'}\n\n'
                '¿Deseas aplicar estos datos?',
                style: GoogleFonts.roboto(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancelar', style: GoogleFonts.roboto()),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                  ),
                  child: Text('Aplicar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );

          if (confirmImport == true && context.mounted) {
            // Mostrar loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Eliminar datos actuales primero
            Provider.of<DebtProvider>(context, listen: false).deleteAll();
            Provider.of<SubscriptionProvider>(context, listen: false).deleteAll();
            Provider.of<ExpenseProvider>(context, listen: false).deleteAll();
            Provider.of<CreditCardProvider>(context, listen: false).deleteAll();
            Provider.of<OverduePaymentProvider>(context, listen: false).deleteAll();
            Provider.of<TaskProvider>(context, listen: false).deleteAll();
            Provider.of<NoteProvider>(context, listen: false).deleteAll();
            Provider.of<CourseProvider>(context, listen: false).deleteAll();

            // Aplicar datos importados
            await BackupService.applyImportedData(
              context: context,
              data: result['data'] as Map<String, dynamic>,
              debtProvider: Provider.of<DebtProvider>(context, listen: false),
              subscriptionProvider: Provider.of<SubscriptionProvider>(context, listen: false),
              expenseProvider: Provider.of<ExpenseProvider>(context, listen: false),
              creditCardProvider: Provider.of<CreditCardProvider>(context, listen: false),
              overduePaymentProvider: Provider.of<OverduePaymentProvider>(context, listen: false),
              taskProvider: Provider.of<TaskProvider>(context, listen: false),
              noteProvider: Provider.of<NoteProvider>(context, listen: false),
              courseProvider: Provider.of<CourseProvider>(context, listen: false),
              settingsProvider: Provider.of<SettingsProvider>(context, listen: false),
            );

            if (context.mounted) {
              Navigator.pop(context); // Cerrar loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Datos importados exitosamente',
                    style: GoogleFonts.roboto(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result?['message'] ?? 'Error al importar los datos',
                style: GoogleFonts.roboto(),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar loading si está abierto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.roboto(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
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
    Provider.of<CreditCardProvider>(context, listen: false).deleteAll();
    Provider.of<OverduePaymentProvider>(context, listen: false).deleteAll();
    Provider.of<TaskProvider>(context, listen: false).deleteAll();
    Provider.of<NoteProvider>(context, listen: false).deleteAll();
    Provider.of<CourseProvider>(context, listen: false).deleteAll();

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
