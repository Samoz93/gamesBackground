import 'package:backgrounds/Tools/BaseProvider.dart';
import 'package:backgrounds/Tools/Consts.dart';
import 'package:backgrounds/Tools/MyImage.dart';
import 'package:backgrounds/services/ImageService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class ImagePagination extends BaseProvider {
  final _db = FirebaseDatabase.instance.reference();
  var newStream;
  final _data2Limit = BehaviorSubject();
  final type;
  bool _isLoading = false;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  ImagePagination({this.type}) {
    newStream = _data2Limit.switchMap((value) {
      final g = _db
          .child(IMAGES2)
          .child(type)
          .orderByChild("createdAt")
          .limitToFirst(value)
          .onValue
          .map(
            (event) => _getClasses(event.snapshot.value),
          );
      isLoading = false;
      return g;
    });
    _data2Limit.add(500);
  }

  extendLimit() {
    isLoading = true;
    _data2Limit.add(_data2Limit.value + 500);
  }

  List<MyImage> _getClasses(val) {
    final data = getMap(val);
    final cls = data.values.map((e) {
      return MyImage.fromJson(getMap(e));
    }).toList()
      ..sort((a, b) => b.createdAt - a.createdAt);
    ;

    return cls;
  }
}
