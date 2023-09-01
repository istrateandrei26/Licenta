class ChangePasswordRequest {
  final int userId;
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest(this.userId, this.oldPassword, this.newPassword);

  Map<String, dynamic> toJson() => 
  {
    'userId': userId,
    'oldPassword': oldPassword,
    'newPassword': newPassword
  };
}
