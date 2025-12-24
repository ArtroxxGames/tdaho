import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/overdue_payment.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/providers/debt_provider.dart';

class AddOverduePaymentForm extends StatefulWidget {
  final OverduePayment? payment;
  final Function(OverduePayment) onSave;

  const AddOverduePaymentForm({super.key, this.payment, required this.onSave});

  @override
  State<AddOverduePaymentForm> createState() => _AddOverduePaymentFormState();
}

class _AddOverduePaymentFormState extends State<AddOverduePaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _debtNameController;
  late TextEditingController _monthController;
  late TextEditingController _amountController;
  late DateTime _dueDate;
  String? _selectedDebtId;

  @override
  void initState() {
    super.initState();
    _debtNameController = TextEditingController(text: widget.payment?.debtName ?? '');
    _monthController = TextEditingController(text: widget.payment?.month ?? '');
    _amountController = TextEditingController(
      text: widget.payment?.amount.toStringAsFixed(0) ?? '',
    );
    _dueDate = widget.payment?.dueDate ?? DateTime.now();
    _selectedDebtId = widget.payment?.debtId;
  }

  @override
  void dispose() {
    _debtNameController.dispose();
    _monthController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPayment = OverduePayment(
        id: widget.payment?.id ?? DateTime.now().toString(),
        debtId: _selectedDebtId,
        debtName: _debtNameController.text,
        month: _monthController.text,
        amount: double.parse(_amountController.text),
        dueDate: _dueDate,
      );
      widget.onSave(newPayment);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.payment == null ? 'Registrar Atraso' : 'Editar Atraso',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String?>(
                value: _selectedDebtId,
                decoration: const InputDecoration(
                  labelText: 'Deuda relacionada (opcional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Ninguna (manual)'),
                  ),
                  ...debtProvider.debts.map((debt) {
                    return DropdownMenuItem<String?>(
                      value: debt.id,
                      child: Text(debt.creditor),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDebtId = value;
                    if (value != null) {
                      final debt = debtProvider.debts.firstWhere((d) => d.id == value);
                      _debtNameController.text = debt.creditor;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _debtNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la deuda *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _monthController,
                decoration: const InputDecoration(
                  labelText: 'Mes del pago atrasado *',
                  hintText: 'Ej: Enero 2024',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El mes es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto (Gs) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El monto es requerido';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Fecha de vencimiento original *'),
                subtitle: Text(
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

