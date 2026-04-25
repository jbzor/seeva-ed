import 'dart:convert';

import 'package:example/models/ressources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

const viewingCard = 'viewingCard';
const startShowShowcaseCard = 'startShowShowcaseCard';
const showShowcase = 'showShowcase';
const showShowcaseCard = 'showShowcase_card';
const Favoris = 'ressources';

final havorisProvider =
    ChangeNotifierProvider<FavorisProvider>((ref) => FavorisProvider());

// ignore: camel_case_types
class FavorisProvider extends ChangeNotifier {
  double _double = 220; //385
  double get sizeScreen => _double;

  List<Ressources> list = [];
  List<Ressources> get getList => list;

  bool _bool = true;
  bool get scroll => _bool;

  bool _statut = true;
  bool get status => _statut;

  void getRessourcesList() {
    list = [];
    List<String>? contactListString =
        CashHelper.sharedPreferences?.getStringList(Favoris);
    if (contactListString != null) {
      list = contactListString
          .map((contact) => Ressources.fromJson(json.decode(contact)))
          .toList();
    }
    notifyListeners();
  }

  void setScroll(bool b) {
    _bool = b;
    _notify();
  }

  void setStatut(bool b) {
    _statut = b;
    _notify();
  }

  void screenBig(double d) {
    _double = d;
    _notify();
  }

  void screenSmall(double d) {
    _double = d;
    _notify();
  }

  void _notify() {
    notifyListeners();
  }
}

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final sharedPrefsProvider = Provider((ref) async {
  List<Ressources>? list;
  final pref = ref.watch(sharedPrefs).maybeWhen(
        data: (value) => value,
        orElse: () => null,
      );
  List<String>? contactListString = pref?.getStringList(Favoris);
  if (contactListString != null) {
    list = contactListString
        .map((contact) => Ressources.fromJson(json.decode(contact)))
        .toList();
  }
  return list ?? [];
});

// class FavoriteIds extends StateNotifier<List<Ressources>> {
//   FavoriteIds(this.pref) : super([]); //pref?.getStringList("id").toList() ??

//   static final provider =
//       StateNotifierProvider<FavoriteIds, List<Ressources>>((ref) {
//     final pref = ref.watch(sharedPrefs).maybeWhen(
//           data: (value) => value,
//           orElse: () => null,
//         );
//     return FavoriteIds(pref);
//   });

//   final SharedPreferences? pref;

//   void toggle(String favoriteId) {
//     if (state.contains(favoriteId)) {
//       state = state.where((id) => id != favoriteId).toList();
//     } else {
//       state = [...state, favoriteId];
//     }
//     // Throw here since for some reason SharedPreferences could not be retrieved
//     pref!.setStringList("id", state);
//   }

// }

class CashHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get prefInstance => sharedPreferences;

  static Future setTheme({required String key, required dynamic value}) async {
    await sharedPreferences!.setBool(key, value);
  }

  static List<Ressources>? getRessourcesList() {
    List<Ressources>? list;
    List<String>? contactListString = sharedPreferences!.getStringList(Favoris);
    if (contactListString != null) {
      list = contactListString
          .map((contact) => Ressources.fromJson(json.decode(contact)))
          .toList();
    }
    return list ?? [];
  }

  static bool? favExist(Ressources data) {
    List<Ressources>? list;
    List<String>? contactListString = sharedPreferences!.getStringList(Favoris);
    if (contactListString != null) {
      list = contactListString
          .map((contact) => Ressources.fromJson(json.decode(contact)))
          .toList();

      bool exist = list.any((element) => element.id == data.id);
      return list != null ? exist : false;
    }
    return false;
  }

  bool resourceExists(List<Ressources> resources, String id) {
    return resources.any((resource) => resource.id == id);
  }

  static Future<bool> addFav(Ressources data) async {
    List<Ressources>? list = getRessourcesList();
    bool b = list!.any((resource) => resource.id == data.id);
    if (b) {
      list.remove(data);
      List<String> contactListString =
          list.map((contact) => jsonEncode(contact.toJson())).toList();
      await sharedPreferences!.setStringList(Favoris, contactListString);
      bool b = list.any((element) => element.id == data.id);
      return !b;
    }
    list.add(data);
    List<String> contactListString =
        list.map((contact) => jsonEncode(contact.toJson())).toList();
    return await sharedPreferences!.setStringList(Favoris, contactListString);
  }

  static Future<bool> removeFav(Ressources data) async {
    // return sharedPreferences!.remove(Favoris);
    List<Ressources>? list = getRessourcesList();
    final int index = list!.indexWhere((element) => element.id == data.id);
    if (kDebugMode) {
      print("list : ${list.length}");
      print("position: $index");
    }
    list.remove(data);
    bool exist = list.any((resource) => resource.id == data.id);
    if (exist) list.removeAt(index);
    if (kDebugMode) {
      print("list after remove : ${list.length}");
    }
    List<String> contactListString =
        list.map((contact) => jsonEncode(contact.toJson())).toList();
    await sharedPreferences!.setStringList(Favoris, contactListString);
    return true;
  }

  static bool? getTheme({required String key}) {
    return sharedPreferences!.getBool(key);
  }

  static Future setHiddenCardAmount(
      {required String key, required dynamic value}) async {
    await sharedPreferences!.setBool(key, value);
  }

  static bool? getHiddenCardAmount({required String key}) {
    return sharedPreferences!.getBool(key);
  }

  static Future setHiddenAmount(
      {required String key, required dynamic value}) async {
    await sharedPreferences!.setBool(key, value);
  }

  static bool? getHiddenAmount({required String key}) {
    return sharedPreferences!.getBool(key);
  }

  static Future setBool({required String key, required dynamic value}) async {
    await sharedPreferences!.setBool(key, value);
  }

  static bool? getBool({required String key}) {
    return sharedPreferences!.getBool(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) return sharedPreferences!.setString(key, value);
    if (value is int) return sharedPreferences!.setInt(key, value);
    if (value is bool) return sharedPreferences!.setBool(key, value);

    return sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeDatabykey({required String key}) async {
    return sharedPreferences!.remove(key);
  }
}
