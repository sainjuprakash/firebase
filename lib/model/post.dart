final post = {
  'title': 'hello title',
  'detail': 'this is detail',
  'postId': 'post id1',
  'userId': '.usere id1',
  'imageId': 'Image Id',
  'imageUrl': 'Image.jpeg',
  'like': {
    'likes': 20,
    'usernames': ['shyam', 'praks']
  },
  'comments': [
    {'username': 'praakash', 'comments': 'nice picture', 'image': 'user.jpeg'}
  ],
};

class Post {
  final String title;
  final String detail;
  final String postId;
  final String userId;
  final String imageId;
  final String imageUrl;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.title,
      required this.detail,
      required this.postId,
      required this.userId,
      required this.imageId,
      required this.imageUrl,
      required this.like,
      required this.comments
      });

  factory Post.FromJson(Map<String, dynamic> json) {
    return Post(
        title: json['title'],
        detail: json['detail'],
        postId: json['postId'],
        userId: json['userId'],
        imageId: json['imageId'],
        imageUrl: json['imageUrl'],
        like: Like.fromJson(json['like']),
        comments: (json['comments'] as List)
            .map((e) => Comment.fromJson(e))
            .toList());
  }
}

class Like {
  final int likes;
  final List<String> username;

  Like({required this.likes, required this.username});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(likes: json['likes'],
        username: (json['usernames'] as List).map((e) => e as String).toList()
    );
  }
}

class Comment {
  final String comment;
  final String username;
  final String image;

  Comment({
    required this.username,
    required this.comment,
    required this.image,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        username: json['username'],
        comment: json['comments'],
        image: json['image']);
  }
  Map toMap() {
    return {
      'username': this.username,
      'comments': this.comment,
      'image': this.image
    };
  }
}
