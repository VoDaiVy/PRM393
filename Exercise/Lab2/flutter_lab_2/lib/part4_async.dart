import 'dart:async';

// Exercise 14: Future delay 2 giây
Future<List<int>> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  return [10, 20, 30, 40, 50];
}

// Exercise 15: Stream phát số mỗi giây
Stream<int> streamCounter() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  print('=== EXERCISE 14: FUTURE DATA LOADING ===');
  print('Đang tải dữ liệu (đợi 2s)...');
  List<int> fetchedData = await loadData();
  print('-> Kết quả Future: $fetchedData\n');

  print('=== EXERCISE 15: STREAM COUNTER ===');
  print('Bắt đầu lắng nghe Stream:');
  
  late StreamSubscription<int> subscription;
  subscription = streamCounter().listen((value) {
    print(' Stream phát ra: $value');
    
    if (value == 5) {
      print('-> Hoàn thành Stream. Hủy kết nối!');
      subscription.cancel();
    }
  });
}