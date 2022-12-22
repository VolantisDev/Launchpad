/// Current sponsors of Launchpad
const sponsors = [
  Sponsor(
    username: 'bmcclure',
    imageUrl: 'https://avatars.githubusercontent.com/u/277977?v=4',
    name: 'Sander in \'t Hout',
  )
];

class Sponsor {
  final String? username;
  final String name;
  final String imageUrl;

  const Sponsor({
    required this.username,
    required this.name,
    required this.imageUrl,
  });

  Sponsor copyWith({
    String? username,
    String? name,
    String? imageUrl,
  }) {
    return Sponsor(
      username: username ?? this.username,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  toString() =>
      'Sponsor(username: $username, name: $name, imageUrl: $imageUrl)';

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sponsor &&
        other.username == username &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  get hashCode => username.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}
