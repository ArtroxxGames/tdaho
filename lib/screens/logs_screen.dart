import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:myapp/models/log.dart';
import 'package:myapp/providers/log_provider.dart';
import 'package:myapp/theme/app_colors.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  DateTime _selectedDate = DateTime.now();
  LogLevel? _selectedLevel;
  String? _selectedCategory;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _exportLogs() async {
    try {
      final logProvider = Provider.of<LogProvider>(context, listen: false);
      final logs = logProvider.exportToJson();
      
      final jsonString = const JsonEncoder.withIndent('  ').convert({
        'exportDate': DateTime.now().toIso8601String(),
        'totalLogs': logs.length,
        'logs': logs,
      });

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final fileName = 'tdaho_logs_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      if (mounted) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Logs de TDAH Organizer',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logs exportados exitosamente', style: GoogleFonts.roboto()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e', style: GoogleFonts.roboto()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteOldLogs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar logs antiguos', style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
        content: Text(
          '¿Deseas eliminar todos los logs con más de 30 días de antigüedad?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: GoogleFonts.roboto()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Eliminar', style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await Provider.of<LogProvider>(context, listen: false).deleteLogsOlderThan(30);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logs antiguos eliminados', style: GoogleFonts.roboto()),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildLast14DaysGrid(),
            const SizedBox(height: 16),
            _buildDateNavigation(),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            Expanded(child: _buildLogsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Logs',
          style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {}),
              tooltip: 'Refrescar',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportLogs,
              tooltip: 'Exportar JSON',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _deleteOldLogs,
              tooltip: 'Eliminar logs antiguos',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLast14DaysGrid() {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        final stats = logProvider.getLast14DaysStats();
        final sortedDates = stats.keys.toList()..sort((a, b) => b.compareTo(a));

        return SizedBox(
          height: 80,
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final dayStats = stats[date]!;
                final isToday = _isSameDay(date, DateTime.now());
                final isSelected = _isSameDay(date, _selectedDate);

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = date),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentPrimary.withOpacity(0.2)
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentPrimary
                            : isToday
                                ? Colors.white24
                                : Colors.transparent,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E('es').format(date).substring(0, 3),
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: isToday ? AppColors.accentPrimary : Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date.day.toString(),
                          style: GoogleFonts.oswald(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isToday ? AppColors.accentPrimary : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayStats['total'].toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
                            ),
                            if (dayStats['error']! > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  dayStats['error'].toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 8,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateNavigation() {
    final isToday = _isSameDay(_selectedDate, DateTime.now());

    return Card(
      color: AppColors.bgCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _previousDay,
              tooltip: 'Día anterior',
            ),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat.yMMMEd('es').format(_selectedDate),
                      style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: isToday ? null : _nextDay,
              tooltip: 'Día siguiente',
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: isToday ? null : _goToToday,
              child: Text(
                'Hoy',
                style: GoogleFonts.roboto(
                  color: isToday ? Colors.white38 : AppColors.accentPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        final categories = logProvider.categories;

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<LogLevel?>(
                value: _selectedLevel,
                decoration: InputDecoration(
                  labelText: 'Nivel',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos')),
                  ...LogLevel.values.map((level) => DropdownMenuItem(
                        value: level,
                        child: Row(
                          children: [
                            Icon(level.icon, color: level.color, size: 16),
                            const SizedBox(width: 8),
                            Text(level.displayName),
                          ],
                        ),
                      )),
                ],
                onChanged: (value) => setState(() => _selectedLevel = value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todas')),
                  ...categories.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )),
                ],
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        final stats = logProvider.getStatsForDate(_selectedDate);

        return Row(
          children: [
            _buildStatChip('Total', stats['total']!, Colors.white70),
            const SizedBox(width: 8),
            _buildStatChip('Info', stats['info']!, Colors.blue),
            const SizedBox(width: 8),
            _buildStatChip('Warning', stats['warning']!, Colors.orange),
            const SizedBox(width: 8),
            _buildStatChip('Error', stats['error']!, Colors.red),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(fontSize: 12, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsTable() {
    return Consumer<LogProvider>(
      builder: (context, logProvider, child) {
        final logs = logProvider.getFilteredLogs(
          date: _selectedDate,
          level: _selectedLevel,
          category: _selectedCategory,
        );

        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, size: 64, color: Colors.white24),
                const SizedBox(height: 16),
                Text(
                  'No hay logs para esta fecha',
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.white54),
                ),
                const SizedBox(height: 8),
                Text(
                  'Los logs se registran automáticamente',
                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return _buildLogCard(log);
          },
        );
      },
    );
  }

  Widget _buildLogCard(AppLog log) {
    return Card(
      color: AppColors.bgCard,
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: log.level.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(log.level.icon, color: log.level.color, size: 20),
        ),
        title: Text(
          log.message,
          style: GoogleFonts.roboto(fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              DateFormat.Hms().format(log.createdAt),
              style: GoogleFonts.robotoMono(fontSize: 11, color: Colors.white54),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.category,
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  color: AppColors.accentSecondary,
                ),
              ),
            ),
          ],
        ),
        children: [
          if (log.metadata != null && log.metadata!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metadata:',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    const JsonEncoder.withIndent('  ').convert(log.metadata),
                    style: GoogleFonts.robotoMono(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

