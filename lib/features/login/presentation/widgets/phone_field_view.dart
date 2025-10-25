import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneFieldView extends StatelessWidget {
  static const supportedLocales = [
    Locale('ar'),
    // not supported by material yet
    // Locale('ckb'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('hu'),
    Locale('it'),
    // not supported by material yet
    // Locale('ku'),
    Locale('nb'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uz'),
    Locale('zh'),
    // ...
  ];

  final PhoneController controller;
  final FocusNode focusNode;
  final CountrySelectorNavigator selectorNavigator;
  final bool withLabel;
  final bool outlineBorder;
  final bool isCountryButtonPersistant;
  final bool mobileOnly;
  final Locale locale;

  const PhoneFieldView({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.selectorNavigator,
    required this.withLabel,
    required this.outlineBorder,
    required this.isCountryButtonPersistant,
    required this.mobileOnly,
    required this.locale,
  }) : super(key: key);

  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Localizations.override(
        context: context,
        locale: locale,
        child: Builder(
          builder: (context) {
            final label = PhoneFieldLocalization.of(context).phoneNumber;
            return PhoneFormField(
              focusNode: focusNode,
              controller: controller,
              isCountryButtonPersistent: isCountryButtonPersistant,
              autofocus: false,
              autofillHints: const [AutofillHints.telephoneNumber],
              countrySelectorNavigator: selectorNavigator,
              decoration: InputDecoration(
                label: withLabel ? Text(label) : null,
                border: outlineBorder
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                    : const UnderlineInputBorder(),
                hintText: withLabel ? '' : label,
                contentPadding: const EdgeInsets.all(0),
              ),
              enabled: true,
              countryButtonStyle: CountryButtonStyle(
                showFlag: true,
                showIsoCode: false,
                showDialCode: true,
                showDropdownIcon: true,
                borderRadius: BorderRadius.circular(50),
              ),

              validator: _getValidator(context),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: Theme.of(context).colorScheme.primary,
              // ignore: avoid_print
              onSaved: (p) => print('saved $p'),
              // ignore: avoid_print
              onChanged: (p) => print('changed $p'),
            );
          },
        ),
      ),
    );
  }
}
