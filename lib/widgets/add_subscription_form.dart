import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/subscription.dart';

class AddSubscriptionForm extends StatefulWidget {
  final Subscription? subscription;
  final Function(Subscription) onSave;

  const AddSubscriptionForm({super.key, this.subscription, required this.onSave});

  @override
  _AddSubscriptionFormState createState() => _AddSubscriptionFormState();
}

class _AddSubscriptionFormState extends State<AddSubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _amount;
  late BillingCycle _billingCycle;
  late DateTime _nextPaymentDate;

  @override
  void initState() {
    super.initState();
    if (widget.subscription != null) {
      _name = widget.subscription!.name;
      _amount = widget.subscription!.amount;
      _billingCycle = widget.subscription!.billingCycle;
      _nextPaymentDate = widget.subscription!.nextPaymentDate;
    } else {
      _name = '';
      _amount = 0.0;
      _billingCycle = BillingCycle.mensual;
      _nextPaymentDate = DateTime.now();
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newSubscription = Subscription(
        id: widget.subscription?.id ?? DateTime.now().toString(),
        name: _name,
        amount: _amount,
        billingCycle: _billingCycle,
        nextPaymentDate: _nextPaymentDate,
      );
      widget.onSave(newSubscription);
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
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduce un nombre';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
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
            DropdownButtonFormField<BillingCycle>(
              value: _billingCycle,
              items: BillingCycle.values.map((cycle) {
                return DropdownMenuItem(
                  value: cycle,
                  child: Text(cycle.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _billingCycle = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Ciclo de Facturación'),
            ),
            ListTile(
              title: Text(
                  'Próximo Pago: ${DateFormat.yMMMd().format(_nextPaymentDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _nextPaymentDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _nextPaymentDate = pickedDate;
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
