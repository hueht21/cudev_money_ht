import 'package:spending/Model/Group.dart';

class ToalGroup extends Group{
  int? toalGroup;

  ToalGroup({idGroup,nameGroup,imgGroup,required this.toalGroup}) : super(idGroup : idGroup  , nameGroup : nameGroup, imgGroup : imgGroup);

  factory ToalGroup.fromMap(Map<String, dynamic> json ) => ToalGroup(toalGroup: json['Tong_Tien'],nameGroup: json['Ten_Nhom']);
}