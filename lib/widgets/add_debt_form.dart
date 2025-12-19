import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/debt.dart';

class AddDebtForm extends StatefulWidget {
  final Debt? debt;
  final Function(Debt) onSave;

  const AddDebtForm({super.key, this.debt, required this.onSave});

  @override
  _AddDebtFormState createState() => _AddDebtFormState();
}

class _AddDebtFormState extends State<AddDebtForm> {
  final _formKey = GlobalKey<FormState>();
  late String _creditor;
  late double _totalAmount;
  late int _totalInstallments;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      _creditor = widget.debt!.creditor;
      _totalAmount = widget.debt!.totalAmount;
      _totalInstallments = widget.debt!.totalInstallments;
      _startDate = widget.debt!.startDate;
    } else {
      _creditor = '';
      _totalAmount = 0.0;
      _totalInstallments = 1;
      _startDate = DateTime.now();
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newDebt = Debt(
        id: widget.debt?.id ?? DateTime.now().toString(),
        creditor: _creditor,
        totalAmount: _totalAmount,
        totalInstallments: _totalInstallments,
        startDate: _startDate,
      );
      widget.onSave(newDebt);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _creditor,
              decoration: const InputDecoration(labelText: 'Acreedor'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce un acreedor';
                }
                return null;
              },
              onSaved: (value) => _creditor = value!,
            ),
            TextFormField(
              initialValue: _totalAmount.toString(),
              decoration: const InputDecoration(labelText: 'Monto Total'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Por favor, introduce un monto válido';
                }
                return null;
              },
              onSaved: (value) => _totalAmount = double.parse(value!),
            ),
            TextFormField(
              initialValue: _totalInstallments.toString(),
              decoration: const InputDecoration(labelText: 'Total de Cuotas'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || int.tryParse(value) == null) {
                  return 'Por favor, introduce un número válido de cuotas';
                }
                return null;
              },
              onSaved: (value) => _totalInstallments = int.parse(value!),
            ),
            ListTile(
              title: Text('Fecha de Inicio: ${DateFormat.yMMMd().format(_startDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _startDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveForm,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
