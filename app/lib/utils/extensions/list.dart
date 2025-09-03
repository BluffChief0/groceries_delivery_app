extension ListExt<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test, [int start = 0]) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        return this[i];
      }
    }
    return null;
  }
}
