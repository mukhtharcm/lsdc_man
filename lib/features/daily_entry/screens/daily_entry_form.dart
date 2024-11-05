import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/daily_entry/daily_entry_bloc.dart';
import '../../../blocs/daily_entry/daily_entry_event.dart';
import '../../../models/daily_entry.dart';
import '../../../config/theme.dart';

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
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: AppTheme.paddingLarge),
                  _buildDenominationsSection(),
                  const SizedBox(height: AppTheme.paddingLarge),
                  _buildOtherDetailsSection(),
                  const SizedBox(height: AppTheme.paddingLarge),
                  FilledButton(
                    onPressed: _submitForm,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.paddingMedium),
                      child: Text(
                        widget.entry == null ? 'Create Entry' : 'Update Entry',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
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

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            FormBuilderDateTimePicker(
              name: 'date',
              inputType: InputType.date,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            FormBuilderTextField(
              name: 'no_of_calendar',
              decoration: const InputDecoration(
                labelText: 'Number of Calendars',
                prefixIcon: Icon(Icons.calendar_view_month),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            FormBuilderTextField(
              name: 'sold_no',
              decoration: const InputDecoration(
                labelText: 'Sold Number',
                prefixIcon: Icon(Icons.sell),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDenominationsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Denominations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.paddingSmall,
              crossAxisSpacing: AppTheme.paddingSmall,
              childAspectRatio: 2.5,
              children: [
                _buildDenominationField('d500', '₹500'),
                _buildDenominationField('d200', '₹200'),
                _buildDenominationField('d100', '₹100'),
                _buildDenominationField('d50', '₹50'),
                _buildDenominationField('d20', '₹20'),
                _buildDenominationField('d10', '₹10'),
                _buildDenominationField('d5', '₹5'),
                _buildDenominationField('d2', '₹2'),
                _buildDenominationField('d1', '₹1'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            FormBuilderTextField(
              name: 'expense',
              decoration: const InputDecoration(
                labelText: 'Expense',
                prefixIcon: Icon(Icons.money_off),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            FormBuilderTextField(
              name: 'batta',
              decoration: const InputDecoration(
                labelText: 'Batta',
                prefixIcon: Icon(Icons.payments),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDenominationField(String name, String label) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.currency_rupee),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
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
        balance: 0, // Calculate based on denominations
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
