class ChatPayload {
  final String? userEmail;
  final String? message;

  final DateTime? createdAt;

  ChatPayload({
    this.userEmail,
    this.createdAt,
    this.message,
  });
  ChatPayload copyWith(
      {String? userEmail, String? message, DateTime? createdAt}) {
    return ChatPayload(
      message: message ?? this.message,
      userEmail: userEmail ?? this.userEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
