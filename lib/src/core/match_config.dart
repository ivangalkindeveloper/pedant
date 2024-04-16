class MatchConfig {
  const MatchConfig({
    this.path,
    required this.matchList,
  });

  final String? path;
  final List<String> matchList;
}
