import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/credit_card.dart';

class AddCreditCardForm extends StatefulWidget {
  final CreditCard? creditCard;
  final Function(CreditCard) onSave;

  const AddCreditCardForm({super.key, this.creditCard, required this.onSave});

  @override
  State<AddCreditCardForm> createState() => _AddCreditCardFormState();
}

class _AddCreditCardFormState extends State<AddCreditCardForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bankController;
  late TextEditingController _lastFourDigitsController;
  late TextEditingController _creditLimitController;
  late int _closingDay;
  late int _dueDay;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.creditCard?.name ?? '');
    _bankController = TextEditingController(text: widget.creditCard?.bank ?? '');
    _lastFourDigitsController = TextEditingController(text: widget.creditCard?.lastFourDigits ?? '');
    _creditLimitController = TextEditingController(
      text: widget.creditCard?.creditLimit?.toStringAsFixed(0) ?? '',
    );
    _closingDay = widget.creditCard?.closingDay ?? 15;
    _dueDay = widget.creditCard?.dueDay ?? 5;
    _notesController = TextEditingController(text: widget.creditCard?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _lastFourDigitsController.dispose();
    _creditLimitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newCard = CreditCard(
        id: widget.creditCard?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        bank: _bankController.text.isEmpty ? null : _bankController.text,
        lastFourDigits: _lastFourDigitsController.text.isEmpty ? null : _lastFourDigitsController.text,
        creditLimit: _creditLimitController.text.isEmpty
            ? null
            : double.tryParse(_creditLimitController.text),
        closingDay: _closingDay,
        dueDay: _dueDay,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isActive: widget.creditCard?.isActive ?? true,
      );
      widget.onSave(newCard);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                widget.creditCard == null ? 'Nueva Tarjeta' : 'Editar Tarjeta',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tarjeta *',
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
                controller: _bankController,
                decoration: const InputDecoration(
                  labelText: 'Banco (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastFourDigitsController,
                decoration: const InputDecoration(
                  labelText: 'Últimos 4 dígitos (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditLimitController,
                decoration: const InputDecoration(
                  labelText: 'Límite de crédito (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _closingDay,
                      decoration: const InputDecoration(
                        labelText: 'Día de cierre *',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(28, (index) => index + 1)
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text('Día $day'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _closingDay = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _dueDay,
                      decoration: const InputDecoration(
                        labelText: 'Día de vencimiento *',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(28, (index) => index + 1)
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text('Día $day'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _dueDay = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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

