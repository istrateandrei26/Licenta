class GoogleSignInRequest {
  final String email;
  final String firstname;
  final String lastname;
  final List<int>? profileImageBytes;

  GoogleSignInRequest(this.email, this.firstname, this.lastname, this.profileImageBytes);

  Map<String, dynamic> toJson() =>
      {'email': email, 'firstname': firstname, 'lastname': lastname, 'profileImageBytes': profileImageBytes
      };
}
