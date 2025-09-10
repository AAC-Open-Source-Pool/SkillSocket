class BackendCommunity {
  final String id;
  final String name;
  final String? bio;
  final String? iconUrl;
  final List<String> tags;
  final int memberCount;
  final List<CommunityPost> posts;
  final DateTime? createdAt; // <-- add this

  BackendCommunity({
    required this.id,
    required this.name,
    this.bio,
    this.iconUrl,
    this.tags = const [],
    this.memberCount = 0,
    this.posts = const [],
    this.createdAt, // <-- add this
  });
}

// Define CommunityPost class as needed
class CommunityPost {
  final String title;
  final String content;

  CommunityPost({required this.title, required this.content});
}
