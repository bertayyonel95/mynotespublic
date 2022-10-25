import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        "We've sent you password reset link. Please check your email for more information",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
