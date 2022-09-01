import 'Items.dart';

class SearchBox {
  SearchBox({
   this.kind,
   this.totalItems,
   this.items,});

  SearchBox.fromJson(dynamic json) {
    kind = json['kind'];
    totalItems = json['totalItems'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
  String? kind;
  int? totalItems;
  List<Items>? items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kind'] = kind;
    map['totalItems'] = totalItems;
    if (items != null) {
      map['items'] = items!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}