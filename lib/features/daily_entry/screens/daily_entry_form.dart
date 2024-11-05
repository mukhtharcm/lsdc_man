import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/daily_entry/daily_entry_bloc.dart';
import '../../../blocs/daily_entry/daily_entry_event.dart';
import '../../../models/daily_entry.dart';

class DailyEntryForm extends StatefulWidget {
  final DailyEntry? entry;

  const DailyEntryForm({super.key, this.entry});

  @override
  State<DailyEntryForm> createState() => _DailyEntryFormState();
}

class _DailyEntryFormState extends State<DailyEntryForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              initialValue: {
                'date': widget.entry?.date ?? DateTime.now(),
                'no_of_calendar': widget.entry?.noOfCalendar.toString() ?? '',
                'sold_no': widget.entry?.soldNo.toString() ?? '',
                'd500': widget.entry?.d500.toString() ?? '0',
                'd200': widget.entry?.d200.toString() ?? '0',
                'd100': widget.entry?.d100.toString() ?? '0',
                'd50': widget.entry?.d50.toString() ?? '0',
                'd20': widget.entry?.d20.toString() ?? '0',
                'd10': widget.entry?.d10.toString() ?? '0',
                'd5': widget.entry?.d5.toString() ?? '0',
                'd2': widget.entry?.d2.toString() ?? '0',
                'd1': widget.entry?.d1.toString() ?? '0',
                'expense': widget.entry?.expense.toString() ?? '0',
                'batta': widget.entry?.batta.toString() ?? '0',
              },
              child: Column(
                children: [
                  FormBuilderDateTimePicker(
                    name: 'date',
                    inputType: InputType.date,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'no_of_calendar',
                    decoration: const InputDecoration(
                      labelText: 'Number of Calendars',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'sold_no',
                    decoration: const InputDecoration(
                      labelText: 'Sold Number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Denominations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildDenominationField('d500', '₹500'),
                  _buildDenominationField('d200', '₹200'),
                  _buildDenominationField('d100', '₹100'),
                  _buildDenominationField('d50', '₹50'),
                  _buildDenominationField('d20', '₹20'),
                  _buildDenominationField('d10', '₹10'),
                  _buildDenominationField('d5', '₹5'),
                  _buildDenominationField('d2', '₹2'),
                  _buildDenominationField('d1', '₹1'),
                  const Divider(height: 32),
                  FormBuilderTextField(
                    name: 'expense',
                    decoration: const InputDecoration(
                      labelText: 'Expense',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'batta',
                    decoration: const InputDecoration(
                      labelText: 'Batta',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      widget.entry == null ? 'Create Entry' : 'Update Entry',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDenominationField(String name, String label) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
      ]),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final user = context.read<AuthBloc>().state.user;

      if (user == null) return;

      final entry = DailyEntry(
        id: widget.entry?.id ?? '',
        userId: user.id,
        teamId: user.teamId ?? '',
        date: values['date'] as DateTime,
        noOfCalendar: int.parse(values['no_of_calendar']),
        soldNo: int.parse(values['sold_no']),
        d500: int.parse(values['d500']),
        d200: int.parse(values['d200']),
        d100: int.parse(values['d100']),
        d50: int.parse(values['d50']),
        d20: int.parse(values['d20']),
        d10: int.parse(values['d10']),
        d5: int.parse(values['d5']),
        d2: int.parse(values['d2']),
        d1: int.parse(values['d1']),
        expense: double.parse(values['expense']),
        batta: double.parse(values['batta']),
        balance: 0, // We can calculate this based on denominations
      );

      if (widget.entry == null) {
        context.read<DailyEntryBloc>().add(CreateDailyEntry(entry));
      } else {
        context.read<DailyEntryBloc>().add(
              UpdateDailyEntry(widget.entry!.id, entry),
            );
      }

      Navigator.pop(context);
    }
  }
}
