import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/theme/app_colors.dart';

class AddDebtForm extends StatefulWidget {
  final Debt? debt;
  final Function(Debt) onSave;

  const AddDebtForm({super.key, this.debt, required this.onSave});

  @override
  _AddDebtFormState createState() => _AddDebtFormState();
}

class _AddDebtFormState extends State<AddDebtForm> {
  final _formKey = GlobalKey<FormState>();
  final _creditorController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _totalInstallmentsController = TextEditingController();
  final _montoCuotaController = TextEditingController();
  final _notasController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  int _dueDay = 1;
  bool _usarCuotaPersonalizada = false;

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      _creditorController.text = widget.debt!.creditor;
      _totalAmountController.text = widget.debt!.totalAmount.toStringAsFixed(0);
      _totalInstallmentsController.text = widget.debt!.totalInstallments.toString();
      _startDate = widget.debt!.startDate;
      _dueDay = widget.debt!.dueDay;
      _notasController.text = widget.debt!.notas ?? '';
      
      if (widget.debt!.montoCuota != null) {
        _usarCuotaPersonalizada = true;
        _montoCuotaController.text = widget.debt!.montoCuota!.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _creditorController.dispose();
    _totalAmountController.dispose();
    _totalInstallmentsController.dispose();
    _montoCuotaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  double? get _cuotaCalculada {
    final total = double.tryParse(_totalAmountController.text);
    final cuotas = int.tryParse(_totalInstallmentsController.text);
    if (total != null && cuotas != null && cuotas > 0) {
      return total / cuotas;
    }
    return null;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final total = double.parse(_totalAmountController.text);
      final cuotas = int.parse(_totalInstallmentsController.text);
      final montoCuota = _usarCuotaPersonalizada && _montoCuotaController.text.isNotEmpty
          ? double.parse(_montoCuotaController.text)
          : null;
      
      final newDebt = Debt(
        id: widget.debt?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        creditor: _creditorController.text.trim(),
        totalAmount: total,
        totalInstallments: cuotas,
        startDate: _startDate,
        dueDay: _dueDay,
        montoCuota: montoCuota,
        notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
        paymentStatus: widget.debt?.paymentStatus,
      );
      widget.onSave(newDebt);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.debt == null ? 'Nueva Deuda' : 'Editar Deuda',
                    style: GoogleFonts.oswald(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Acreedor
              TextFormField(
                controller: _creditorController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la deuda *',
                  hintText: 'Ej: Préstamo Personal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                style: GoogleFonts.roboto(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Monto Total y Cuotas
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _totalAmountController,
                      decoration: InputDecoration(
                        labelText: 'Monto Total (Gs) *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: AppColors.bgSecondary,
                      ),
                      style: GoogleFonts.roboto(),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || double.tryParse(value) == null) {
                          return 'Monto inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _totalInstallmentsController,
                      decoration: InputDecoration(
                        labelText: 'Cuotas *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: AppColors.bgSecondary,
                      ),
                      style: GoogleFonts.roboto(),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed < 1) {
                          return 'Mín. 1';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Cuota calculada o personalizada
              if (_cuotaCalculada != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accentPrimary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cuota mensual calculada:',
                        style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '₲ ${NumberFormat('#,###', 'es').format(_cuotaCalculada)}',
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _usarCuotaPersonalizada,
                  onChanged: (value) => setState(() => _usarCuotaPersonalizada = value ?? false),
                  title: Text(
                    'Usar cuota personalizada',
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                if (_usarCuotaPersonalizada) ...[
                  TextFormField(
                    controller: _montoCuotaController,
                    decoration: InputDecoration(
                      labelText: 'Cuota Mensual (Gs)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: AppColors.bgSecondary,
                    ),
                    style: GoogleFonts.roboto(),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
              const SizedBox(height: 8),
              // Día de vencimiento
              Text(
                'Día de Vencimiento *',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _dueDay,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                items: List.generate(28, (index) => index + 1)
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text('Día $day'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _dueDay = value ?? 1),
              ),
              const SizedBox(height: 16),
              // Fecha de inicio
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() => _startDate = pickedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha de Inicio',
                            style: GoogleFonts.roboto(fontSize: 12, color: Colors.white54),
                          ),
                          Text(
                            DateFormat.yMMMd('es').format(_startDate),
                            style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notas
              TextFormField(
                controller: _notasController,
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Ej: Tasa de interés, banco, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.bgSecondary,
                ),
                style: GoogleFonts.roboto(),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
