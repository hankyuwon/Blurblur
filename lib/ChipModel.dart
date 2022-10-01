import 'package:flutter/material.dart';

class ChipModel with ChangeNotifier{
  final String id;
  final String name;

  ChipModel({required this.id, required this.name});
}