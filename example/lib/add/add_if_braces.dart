void sort({
  required List<String> strings,
}) {
  // expect_lint: add_if_braces
  if (strings.isEmpty) return;

  strings.sort();
}
