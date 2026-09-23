class Assets {
  Assets._();

  static const loading = 'assets/animations/loading.json';

  static const empty = 'assets/images/empty.svg';
  static const error404 = 'assets/images/404.svg';
  static const welcome = 'assets/images/welcome.svg';
  static const avatar = 'assets/images/avatar.webp';
  static const cypherDancer = 'assets/images/cypher-dancer.webp';
  static const danceFloorPreview = 'assets/images/dance-floor-preview.webp';
  static const studioDancerPreview = 'assets/images/studio-dancer-preview.webp';

  /// Editorial placeholders, never demonstrations of the adjacent exercise.
  static const practicePreviewPhotos = [
    studioDancerPreview,
    cypherDancer,
    danceFloorPreview,
  ];
}
