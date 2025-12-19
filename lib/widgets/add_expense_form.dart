import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/expense.dart';

class AddExpenseForm extends StatefulWidget {
  final Expense? expense;
  final Function(Expense) onSave;

  const AddExpenseForm({super.key, this.expense, required this.onSave});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late double _amount;
  late ExpenseCategory _category;
  late PaymentMethod _paymentMethod;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _description = widget.expense!.description;
      _amount = widget.expense!.amount;
      _category = widget.expense!.category;
      _paymentMethod = widget.expense!.paymentMethod;
      _date = widget.expense!.date;
    } else {
      _description = '';
      _amount = 0.0;
      _category = ExpenseCategory.Otros;
      _paymentMethod = PaymentMethod.Tarjeta;
      _date = DateTime.now();
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newExpense = Expense(
        id: widget.expense?.id ?? DateTime.now().toString(),
        description: _description,
        amount: _amount,
        category: _category,
        paymentMethod: _paymentMethod,
        date: _date,
      );
      widget.onSave(newExpense);
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
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce una descripción';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
            TextFormField(
              initialValue: _amount.toString(),
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Por favor, introduce un monto válido';
                }
                return null;
              },
              onSaved: (value) => _amount = double.parse(value!),
            ),
            DropdownButtonFormField<ExpenseCategory>(
              value: _category,
              items: ExpenseCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            DropdownButtonFormField<PaymentMethod>(
              value: _paymentMethod,
              items: PaymentMethod.values.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Método de Pago'),
            ),
            ListTile(
              title: Text('Fecha: ${DateFormat.yMMMd().format(_date)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _date = pickedDate;
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
