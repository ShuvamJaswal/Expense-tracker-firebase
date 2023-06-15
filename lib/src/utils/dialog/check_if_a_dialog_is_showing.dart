import 'package:flutter/material.dart';

checkIfADialogIsShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;
