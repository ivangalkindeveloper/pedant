// expect_lint: delete_new
final List list = new List.empty();

void add() {
  list.add(
    // expect_lint: delete_new
    new List.empty(),
  );
}
