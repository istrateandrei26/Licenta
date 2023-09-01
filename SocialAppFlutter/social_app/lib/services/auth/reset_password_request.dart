class ResetPasswordRequest {
  final String resetCode;
  final String newPassword;

  ResetPasswordRequest(this.resetCode, this.newPassword);

  Map<String, dynamic> toJson() => 
  {
    'resetCode': resetCode,
    'newPassword': newPassword
  };
}
