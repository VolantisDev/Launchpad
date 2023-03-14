/// Current contributors of Launchpad
const contributors = [
  Contributor(
    username: 'bmcclure',
    imageUrl: 'https://avatars.githubusercontent.com/u/277977?v=4',
    name: 'Ben McClure',
  )
];

class Contributor {
  final String? username;
  final String name;
  final String imageUrl;

  const Contributor({
    required this.username,
    required this.name,
    required this.imageUrl,
  });

  Contributor copyWith({
    String? username,
    String? name,
    String? imageUrl,
  }) {
    return Contributor(
      username: username ?? this.username,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  toString() =>
      'Contributor(username: $username, name: $name, imageUrl: $imageUrl)';

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contributor &&
        other.username == username &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  get hashCode => username.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
