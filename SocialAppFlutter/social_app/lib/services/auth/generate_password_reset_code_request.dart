class GeneratePasswordResetCodeRequest {
  final String email;

  GeneratePasswordResetCodeRequest(this.email);

  Map<String, dynamic> toJson() => 
  {
    'email': email,
  };
}
