class RegisterRequest {
  final String username;
  final String email;
  final String lastname;
  final String firstname;
  final String password;

  RegisterRequest(this.username, this.email, this.lastname, this.firstname, this.password);

  Map<String, dynamic> toJson() => 
  {
    'username': username,
    'email': email,
    'lastname': lastname,
    'firstname': firstname,
    'password': password,
  };

}
