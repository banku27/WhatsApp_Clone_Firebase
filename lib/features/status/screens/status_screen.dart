import 'package:flutter/material.dart';

import 'package:whatsapp_ui/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  final Status status;
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {}
}
