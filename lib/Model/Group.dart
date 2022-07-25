class Group {
  int? idGroup;
   String? nameGroup;
   String? imgGroup;

  Group({this.idGroup = 0,required this.nameGroup,required this.imgGroup});


  factory Group.fromMap(Map<String, dynamic> json ) => Group(idGroup : json['id'],nameGroup: json['Ten_Nhom'], imgGroup: json['Anh_Nhom']);

  String? get getNameGroup
  {
    return nameGroup;
  }
}
