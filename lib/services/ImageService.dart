import 'package:backgrounds/Tools/BaseProvider.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Tools/MyImage.dart';
import 'package:firebase_database/firebase_database.dart';

const IMAGES = "Images";
const IMAGES2 = "Images2";
const TYPES = "Types";

class ImageService extends BaseProvider {
  // final _imgs = BehaviorSubject<List<String>>();
  final _db = FirebaseDatabase.instance.reference();
  Stream<List<MyImage>> getImageStream({type = "Apex", limit = 10}) {
    return _db
        .child(IMAGES2)
        .child(type)
        .orderByChild("createdAt")
        .limitToFirst(limit)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return [];
      return _getClasses(event.snapshot.value);
    });
  }

  Future<List<MyImage>> getImagesFuture(
      {type = "Apex", limit = 2, int index}) async {
    DataSnapshot data;
    data = await _db
        .child(IMAGES2)
        .child(type)
        .orderByChild("createdAt")
        .limitToFirst(index == 0 ? 2 : index)
        .once();

    final g = _getClasses(data.value);
    return g;
  }

  List<MyImage> _getClasses(val) {
    final data = getMap(val);
    final cls = data.values.map((e) => MyImage.fromJson(getMap(e))).toList();
    return cls;
  }

  // rewriteData() async {
  //   final images = await getImagesFuture(type: "Fortnite");

  //   for (var img in images) {
  //     await _db.child("Images2").child("Fortnite").push().update({
  //       'url': img.toString(),
  //       'createdAt': DateTime.now().millisecondsSinceEpoch
  //     });
  //   }
  // }

  // fetchData(){
  //   final val = _imgs.value;
  // }
  // _fetch(type,limit,lastVal,lastKey) async {
  //   return await _db.child(IMAGES).child(type).startAt(value) limitToFirst(limit)
  // }
  Stream<List<dynamic>> get types {
    return _db.child(TYPES).onValue.map((event) {
      final x = getMap(event.snapshot.value);
      return x.values.toList();
    });
  }
}
