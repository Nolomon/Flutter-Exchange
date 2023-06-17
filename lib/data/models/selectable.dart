class Selectable<T> {
  final T value;
  final String text;
  bool selected;
  Selectable(this.value, this.text, [this.selected = false]);

  Selectable<T> copyWith({
    T? value,
    String? text,
    bool? selected,
  }) {
    return Selectable(
      value ?? this.value,
      text ?? this.text,
      selected ?? this.selected,
    );
  }
}
