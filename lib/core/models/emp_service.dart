import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<EmpService> servicesAll = [
  EmpService(
      icon: "assets/icons/services/cooking.png",
      name: "Cuisine",
      subServices: [
        EmpService(name: "Cuisinier(ère)"),
        EmpService(name: "Sous-chef"),
        EmpService(name: "Plongeur(se)"),
        EmpService(name: "Pâtissier")
      ]),
  EmpService(
      icon: "assets/icons/services/shampoo.png",
      name: "Hygiène",
      subServices: [
        EmpService(name: "Cuisinier(ère)"),
        EmpService(name: "Sous-chef"),
        EmpService(name: "Plongeur(se)"),
        EmpService(name: "Pâtissier")
      ]),
  EmpService(
      icon: "assets/icons/services/healthcare.png",
      name: "Soin",
      subServices: [
        EmpService(name: "Cuisinier(ère)"),
        EmpService(name: "Sous-chef"),
        EmpService(name: "Plongeur(se)"),
        EmpService(name: "Pâtissier")
      ]),
  EmpService(icon: "assets/icons/services/chef.png", name: "Salle", subServices: [
    EmpService(name: "Cuisinier(ère)"),
    EmpService(name: "Sous-chef"),
    EmpService(name: "Plongeur(se)"),
    EmpService(name: "Pâtissier")
  ]),
];

class EmpService {
  String name;
  String? icon;
  List<EmpService>? subServices;

  EmpService({required this.name, this.icon, this.subServices});
}
